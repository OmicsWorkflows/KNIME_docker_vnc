#!/bin/bash

# shows the notification about the initiated task
notify-send -i software-update-available "Workflows templates repository" \
"<b>Repository reset started!</b> \
\rPlease wait till it is finished..."

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/KNIME_workflows

# checks whether the repository folder exists and shows notification if not
if [ ! -d "$directory" ]; then
  # shows the notification about the missing repository folder
  notify-send -u critical -i dialog-error "Metanodes templates repository" \
  "<b>Repository folder is not present!</b> \
  \rExpected directory: \
  \r$directory"
  exit 1
fi

# navigates to the KNIME_Workflows repository
cd $directory

# resets the repository; change "master" branch to the appropriate one if needed
git fetch origin
git reset --hard origin/master
# removes also not tracked folders and files
git clean -f -d

# shows the notification about the finished task
notify-send -u critical -i process-completed "Workflows templates repository" \
"<b>Repository reset completed!</b> \
\rYou can start to use them in KNIME! \
\rWorkspace refresh in KNIME may be needed! \
\rClick here to hide the notification"
