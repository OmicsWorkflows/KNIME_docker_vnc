#!/bin/bash

# Github repository checked
repo=KNIME_workflows

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/"$repo"

# branch to reset the repository to
# replace the 'master' with the name of the respective branch you want to reset to based on the info on Github
branch=master

# default git fetch response (without whitespaces, tabs, etc.)
FETCH_def="Fromhttps://github.com/OmicsWorkflows/$repo*branch$branch->FETCH_HEAD"

# buttons texts
button_stop="stop"
button_change="change"

# time to wait between individual fetch attempts (default value in case the adjusted once would not be ok...)
waittime_def=6d
waittime="$waittime_def"

# output file with some info for the user and some default values
outputfile=~/${repo}_check_status
text_watching="${repo} repository is being checked for changes regularly"
text_notwatching="${repo} repository is not checked for changes"

###############################################################################

# checks the outputfile presence and status and shows info that the check script is already running
if test -f ${outputfile}; then
  read check_status < ${outputfile}
  if [[ "$check_status" == "$text_watching" ]]; then
    zenity --warning --text="$repo is already being checked for changes, will exit now."  --width=300
    exit 0
  else
    zenity --info --text="$repo has started to be checked for changes.\n\nThe 1st check will happen now and the next one will be in ${waittime}.\n\nYou can verify that the check is running by the following file inspection:\n${outputfile}"  --width=550
  fi
else
  zenity --info --text="$repo has started to be checked for changes.\n\nThe 1st check will happen now and the next one will be in ${waittime}.\n\nYou can verify that the check is running by the following file inspection:\n${outputfile}"  --width=550
fi

# creates variable to hold info whether to rerun the script again
rerun=yes

# the main while loop to run fetch after some specified time
while [ "$rerun" = yes ]
do

# checks whether the repository folder exists and shows notification if not
if [ ! -d "$directory" ]; then
  # shows the notification about the missing repository folder
  zenity --error --text="$repo directory checked for updates does not exists!\n\nChecked repository directory:\n$directory\n\nThe script will exit now. If you want to wath the $repo repository for updates, contact technical support." --title="$repo directory does not exists!"  --width=300
  exit 1
fi

# navigates to the KNIME_Workflows repository
cd "$directory"

# writes the output file to be able to monitor the check status
#echo "writes the output file"
echo "$text_watching" > "$outputfile"

# fetches the status of the remote branch
FETCH=$(git fetch origin "$branch" 2>&1)

# checks whether there is any error during the remote branch fetching and returns error if it is the case
if [ "$?" -ne 0 ]; then
  echo "Attempt to fetch $branch branch returned error";
  echo "$FETCH"
  zenity --error --text="Attempt to fetch remote branch returned error\n\nThe remote branch might be missing.\n\Please contact technical support with the following details:\n\nreturned error:\n$FETCH\n\nchecked branch name:\n$branch" --title="Fetching remote branch returned error!"  --width=300
  # writes the output file to be able to monitor the check status
  echo "$text_notwatching" > "$outputfile"
  exit 1;
else
  # just gets rid of any spaces, tabs etc. for better comparisong with the expected value when there is no update
  FETCH=${FETCH//[[:space:]]/}
  #echo "$FETCH"
  # check the fetch result with the expected value if no update is present
  if [[ "$FETCH" == "$FETCH_def" ]]; then
    # just output some info into the console, but there is no info visible to leave it silent if not run from the commandline
    echo "no change in the $branch branch"
    echo "waiting for $waittime and will check for the changes again"
    # waits for the specified time prior it proceeds with the next iteration of the branch check
    echo "$text_watching" > "$outputfile"
    sleep $waittime
  else
    # in case the fetch result is different to the expected one, i.e. the branch has some remote changes
    echo "remote branch $branch has changed"
    # the 2nd while loop to assure there will be correct check interval set
    interval=notset
    while [ "$interval" = notset ]
    do
    # brings up window with the information about the updated branch with some potential scenarios
    ## these scenarios are covered
    ### 1) just confirms the change, nothing more is done and the next iteration will be initiated after the defined interval
    ### 2) changes the check interval and waits for the adjusted time prior the next iteration; the adjusted time will be remembered
    ### 3) user askes to cancel this automatic check routine
    ans=$(zenity --info --title "Updates for the $repo found!" \
                 --text "Updates for the $repo, branch $branch, were found.\n\nPlease update the $repo manually using the shortcut on the desktop.\n\nIf you do not wish to update, ignore this message. The $repo will be checked for updates in the next $waittime. If you wish to change the time in which the updates will be checked, press $button_change button.\n\nIf you wish to stop to check $repo for updates, press the $button_stop button or press Esc." \
                 --ok-label "ok" \
                 --extra-button "$button_change" \
                 --extra-button "$button_stop" \
                 --width=300)
    rc=$?
    #echo "${rc}-${ans}"
    # based on the type and text of the response the next actions are considered
    if [[ "${rc}-${ans}" == "1-$button_change" ]]; then
      # dialog to change the default/previously set interval length
      ans2=$(zenity --entry --text="Please enter the new value to replace $waittime:\n(acceptable format is e.g. 10h or 2d\nfor 10 hours or 2 days, respectively):" --title="Udates interval change")
      rc2=$?
      #echo "${rc2}-${ans2}"
      # these situations are handled
      ## 1) form is canceled. resets the initial question by going to the beginning of the 2nd while loop
      ## 2) empty string is entered, resets the initial question by going to the beginning of the 2nd while loop
      ## 3) something has been provided that is going to be checked that it is valid format for the sleep command
      if [[ "${rc2}" == "1" ]]; then
        zenity --warning --text="New interval entry was canceled, will ask again what should be done." --title="Interval change canceled" --width=300
        interval=notset
        continue
      elif [[ "${ans2}" == "" ]]; then
        zenity --warning --text="You have provided no value, will ask again what should be done." --title="No value provided!" --width=300
        interval=notset
        continue
      else
        # sets new waittime variable as per the entered value; strips spaces and other characters to make it more robust
        # the provided value is tested further
        waittime=${ans2//[[:space:]]/}
        interval=set
      fi
    elif [[ "${rc}-${ans}" == "1-$button_stop" ]] || [[ "${rc}-${ans}" == "1-" ]]; then
      zenity --info --text="You have asked not to watch $repo for the updates. Exiting.\n\nInitiate the updates watch script manually if you would like to resume it later." --title="$repo updates watch stopped!" --width=300
      echo "$text_notwatching" > "$outputfile"
      exit 1
    fi
    { # tries to set it to sleep for the adjusted interval and returns warning dialog, sets the interval to the default value and restarts the 2nd while loop
      echo "waiting for $waittime and will run the script again"
      echo "$text_watching" > "$outputfile"
      sleep $waittime
    } || { # catch error and shows warning message
      zenity --warning --text="The provided interval time $waittime is not in valid format.\n\nThe interval set back to the default value $waittime_def.\n\nWill ask again what should be done." --title="Not valid interval value!" --width=300
      waittime="$waittime_def"
      interval=notset
    }
    done
  fi
fi
done
echo "Exiting Program"
echo "$text_notwatching" > "$outputfile"
exit 0