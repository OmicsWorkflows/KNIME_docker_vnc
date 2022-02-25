#!/bin/bash

# Github repository checked
repo=KNIME_metanodes

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/$repo

# branch to reset the repository to
# replace the 'master' with the name of the respective branch you want to reset to based on the info on Github
branch=origin/master

# shows the notification about the initiated task
notify-send -i software-update-available "${repo} repository" \
"<b>Repository (${branch} branch) reset started!</b> \
\rPlease wait till it is finished..."

# checks whether the repository folder exists and shows notification if not
if [ ! -d "$directory" ]; then
  # shows the notification about the missing repository folder
  notify-send -u critical -i dialog-error "${repo} repository" \
  "<b>Repository folder is not present!</b> \
  \rExpected directory: \
  \r$directory"
  exit 1
fi

# navigates to the repository folder
cd "$directory"

if [ -n "`git show-ref --verify refs/remotes/"$branch"`" ]; then
  # resets the repository
  git fetch origin
  git reset --hard "$branch"
  # removes also not tracked folders and files
  git clean -f -d
else
  echo "${branch} branch does not exists!"
  zenity --error --text="Branch does not exists!\n\nIt might have been deleted recently.\nPlease verify and adjust the script file accordingly.\n\nChecked branch name:\n"$branch"" --title="Branch does not exists!"  --width=300
  exit 1
fi

# shows the notification about the finished task
notify-send -u critical -i process-completed "${repo} repository" \
"<b>Repository (${branch} branch) reset completed!</b> \
\rYou can start to use them in KNIME! \
\rWorkspace refresh in KNIME may be needed! \
\rClick here to hide the notification"