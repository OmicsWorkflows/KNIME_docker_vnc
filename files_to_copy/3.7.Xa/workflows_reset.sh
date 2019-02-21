#!/bin/bash

# navigates to the KNIME_Workflows repository, change the folder if needed
cd /home/knimeuser/knime-workspace/gitfolders/KNIME_Workflows

# resets the repository; change "master" branch to the appropriate one if needed
git fetch origin
git reset --hard origin/master
# removes also not tracked folders and files
git clean -f -d

# shows the notification about the finished task
notify-send "Workflows reset completed!"
