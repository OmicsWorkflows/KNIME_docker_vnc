#!/bin/bash

# Github repository checked
repo=KNIME_metanodes

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/$repo

# branch to reset the repository to
# replace the 'master' with the name of the respective branch you want to reset to based on the info on Github
branch=${dockerfile_version}

# checks whether the repository folder exists and shows notification if not
if [ ! -d "$directory" ]; then
  # shows the notification about the missing repository folder
  notify-send -u critical -i dialog-error "${repo} repository" \
  "<b>Repository folder is not present!</b> \
  \rExpected directory: \
  \r$directory"
  exit 1
fi

# shows the notification about the initiated task
notify-send -i software-update-available "${repo} repository" \
"<b>Repository (${branch} branch) reset started!</b> \
\rPlease wait till it is finished..."

# navigates to the repository folder
cd "$directory"

if [ -n "`git ls-remote --heads origin refs/heads/"$branch"`" ]; then
  # resets the repository; in case there is error message in any command, the error window will be displayed
  git_return1=$(git fetch origin 2>&1)
  if [ $? != 0 ] ; then
    # shows the notification about the error in the git command
    notify-send -u critical -i dialog-error "${repo} repository" \
    "<b>Git command has not finished successfully!</b> \
    \rError message got by the following git command: \
    \r'git fetch origin': \
    \r \
    \r${git_return1} \
    \r \
    \r<b>Please contact support with the abovementioned error messages!</b>"
    exit 1
  fi
  git_return2=$(git reset --hard origin/"$branch" 2>&1)
  if [ $? != 0 ] ; then
    # shows the notification about the error in the git command
    notify-send -u critical -i dialog-error "${repo} repository" \
    "<b>Git command has not finished successfully!</b> \
    \rError message got by the following git command: \
    \r'git reset --hard origin/"$branch"': \
    \r \
    \r${git_return2} \
    \r \
    \r<b>Please contact support with the abovementioned error messages!</b>"
    exit 1
  fi
  # removes also not tracked folders and files
  git_return3=$(git clean -f -d 2>&1)
  if [ $? != 0 ] ; then
    # shows the notification about the error in the git command
    notify-send -u critical -i dialog-error "${repo} repository" \
    "<b>Git command has not finished successfully!</b> \
    \rError message got by the following git command: \
    \r'git clean -f -d': \
    \r \
    \r${git_return3} \
    \r \
    \r<b>Please contact support with the abovementioned error messages!</b>"
    exit 1
  fi
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