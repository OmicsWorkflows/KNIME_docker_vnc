#!/bin/bash

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/KNIME_metanodes
# file to hold the last used branch
last_branch_file=~/.last_branch_metanodes

# checks whether the repository folder exists and shows notification if not
if [ ! -d "$directory" ]; then
  # shows the notification about the missing repository folder
  notify-send -u critical -i dialog-error "Metanodes templates repository" \
  "<b>Repository folder is not present!</b> \
  \rExpected directory: \
  \r$directory"
  exit 1
fi

# navigates to the KNIME_Metanodes repository
cd "$directory"

# gets the list of all remote branches
MULTILINE=`git branch -r | grep -v ‘remotes’ \
  -1`

# checks the presence of file holding the last used branch and if it is not present, sets master branch as the last used
if test -f $last_branch_file; then
  read LAST_BRANCH < $last_branch_file
else
  LAST_BRANCH="master"
fi

# while loop to ask again in case of empty branch name selected
while true; do
  ENTRY=`zenity --list --column="GitHub branches - KNIME metanode templates" "master" ${LAST_BRANCH} "" ${MULTILINE} --height=300 --width=500 --title="GitHub branch selection"`
  case $? in
     0)
        if [ $ENTRY == "master" ]; then
          branch="origin/master"
        elif [ -z "${ENTRY}" ]; then
          zenity --warning --text="No branch name specified. Please, select again." --title="No branch name"  --width=200
          continue
        else
          branch=$ENTRY
        fi
        if [ -n "`git show-ref --verify refs/remotes/"$branch"`" ]; then
          #echo 'branch exists!'
          # resets the repository; change "master" branch to the appropriate one if needed
          #git fetch origin
          #git reset --hard $branch
          # removes also not tracked folders and files
          #git clean -f -d
          # writes down small file that will hold the last used branch name
          #echo $branch > $last_branch_file
          break
        else
          echo 'branch does not exists!'
          zenity --error --text="Selected branch does not exists!\n\nIt might have been deleted recently.\nPlease verify and select again.\n\nChecked branch name:\n"$branch"" --title="Branch does not exists!"  --width=300
          continue
        fi
        break
        ;;
     1)
     	exit 1
        ;;
    -1)
        zenity --error --text="An unexpected error has occurred." --title="Error!"  --width=200
        exit 1
  esac
done
echo "branch set to $branch"

# shows the notification about the initiated task
notify-send -i software-update-available "Metanodes templates repository" \
"<b>Repository reset started!</b> \
\rPlease wait till it is finished..."

# resets the repository; change "master" branch to the appropriate one if needed
git fetch origin
git reset --hard $branch
# removes also not tracked folders and files
git clean -f -d
# writes down small file that will hold the last used branch name

# shows the notification about the finished task
notify-send -u critical -i process-completed "Metanodes templates repository" \
"<b>Repository reset completed!</b> \
\rYou can start to use them in KNIME! \
\rWorkspace refresh in KNIME may be needed! \
\rClick here to hide the notification"