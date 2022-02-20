#!/bin/bash

# Github repository checked
repo=KNIME_metanodes

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

###############################################################################

# creates variable to hold info whether to rerun the script again
rerun=yes

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

# fetches the status of the remote branch
FETCH=$(git fetch origin "$branch" 2>&1)

# checks whether there is any error during the remote branch fetching and returns error if it is the case
if [ "$?" -ne 0 ]; then
  echo "Attempt to fetch $branch branch returned error";
  echo "$FETCH"
  zenity --error --text="Attempt to fetch remote branch returned error\n\nThe remote branch might be missing.\nPlease contact technical support with the following details:\n\nreturned error:\n$FETCH\n\nchecked branch name:\n$branch" --title="Fetching remote branch returned error!"  --width=300
  exit 1;
else
  FETCH=${FETCH//[[:space:]]/}
  echo "$FETCH"
  if [[ "$FETCH" == "$FETCH_def" ]]; then
    echo "no change in the $branch branch"
    interval=notset
    while [ "$interval" = notset ]
    do
    ans=$(zenity --info --title "Updates for the $repo found!" \
                 --text "Updates for the $repo, branch $branch, were found.\n\nPlease update the $repo manually using the shortcut on the desktop.\n\nIf you do not wish to update, ignore this message. The $repo will be checked for updates in the next $waittime. If you wish to change the time in which the updates will be checked, press $button_change button.\n\nIf you wish to stop to check $repo for updates, press the $button_stop button or press Esc." \
                 --ok-label "ok" \
                 --extra-button "$button_change" \
                 --extra-button "$button_stop" \
                 --width=300)
    rc=$?
    echo "${rc}-${ans}"
    if [[ "${rc}-${ans}" == "1-$button_change" ]]; then
      ans2=$(zenity --entry --text="Please enter the new value to replace $waittime:\n(acceptable format is e.g. 10h or 2d\nfor 10 hours or 2 days, respectively):" --title="Udates interval change")
      rc2=$?
      echo "${rc2}-${ans2}"
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
        waittime=${ans2//[[:space:]]/}
        interval=set
      fi
    elif [[ "${rc}-${ans}" == "1-$button_stop" ]] || [[ "${rc}-${ans}" == "1-" ]]; then
      zenity --info --text="You have asked not to watch $repo for the updates. Exiting.\n\nInitiate the updates watch script manually if you would like to resume it later." --title="$repo updates watch stopped!" --width=300
      exit 1
    fi
    echo "waiting for $waittime and will run the script again"
    { #try
      sleep $waittime
    } || { #catch
      zenity --warning --text="The provided interval time $waittime is not in valid format.\n\nThe interval set back to the default value $waittime_def.\n\nWill ask again what should be done." --title="Not valid interval value!" --width=300 $$
      waittime="$waittime_def"
      interval=notset
    }
    done
  else
    echo "not the same"
    echo "waiting for $waittime and will run the script again"
    sleep $waittime
  fi
fi

done

echo "Exiting Program"
exit 0