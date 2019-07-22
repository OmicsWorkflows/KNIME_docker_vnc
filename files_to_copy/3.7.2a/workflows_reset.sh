#!/bin/bash

# shows the notification about the initiated task
notify-send -i software-update-available "Workflows templates repository" \
"<b>Repository reset started!</b> \
\rPlease wait till it is finished..."

# navigates to the KNIME_Workflows repository, change the folder if needed
cd /home/knimeuser/knime-workspace/gitfolders/KNIME_workflows

# resets the repository; change "master" branch to the appropriate one if needed
git fetch origin
git reset --hard origin/master
# removes also not tracked folders and files
git clean -f -d

# shows the notification about the finished task
notify-send -i process-completed "Workflows templates repository" \
"<b>Repository reset completed!</b> \
\rYou can start to use them in KNIME! \
\rWorkspace refresh may be needed..."
