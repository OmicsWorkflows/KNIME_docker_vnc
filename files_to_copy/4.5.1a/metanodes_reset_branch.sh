#!/bin/bash

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/KNIME_metanodes

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

MULTILINE=`git branch -r | grep -v ‘remotes’ \
  -1`

ENTRY=`zenity --list --column="GitHub branches - KNIME metanode templates" "master" ${MULTILINE} --height=500 --width=500 --title="GitHub branch selection"`

case $? in
   0)
      if (($ENTRY == "master"))
      then
        branch="origin/master"
      else
        branch=$ENTRY
      fi
      ;;
   1)
      exit 1
      ;;
  -1)
      zenity --error --text="An unexpected error has occurred." --title="Error!"  --width=200
      exit 1
esac

echo "branch set to $branch"

# shows the notification about the initiated task
notify-send -i software-update-available "Metanodes templates repository" \
"<b>Repository reset started!</b> \
\rPlease wait till it is finished..."

# resets the repository; change "master" branch to the appropriate one if needed
git fetch origin
#git reset --hard origin/master
git reset --hard $branch
# removes also not tracked folders and files
git clean -f -d

# shows the notification about the finished task
notify-send -u critical -i process-completed "Metanodes templates repository" \
"<b>Repository reset completed!</b> \
\rYou can start to use them in KNIME! \
\rWorkspace refresh in KNIME may be needed! \
\rClick here to hide the notification"