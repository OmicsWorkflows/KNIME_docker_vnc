#!/bin/bash

# repository to use
repo=KNIME_workflows

# default branch
branch_def=master

# repository directory
directory=/home/knimeuser/knime-workspace/gitfolders/${repo}
extract_dir="$directory/Workflow_unpacked"

# file to hold the last used branch
last_branch_file=~/.last_branch_${repo}

# checks whether the repository folder exists and shows notification if not
if [ ! -d "$directory" ]; then
  # shows the notification about the missing repository folder
  notify-send -u critical -i dialog-error "${repo} repository" \
  "<b>Repository folder is not present!</b> \
  \rExpected directory: \
  \r$directory"
  exit 1
fi

# navigates to the KNIME_Metanodes repository
cd "$directory"

# gets the list of all remote branches
MULTILINE=`git ls-remote --heads | awk -F'/' '{print $3}'`

# checks the presence of file holding the last used branch and if it is not present, sets master branch as the last used
if test -f ${last_branch_file}; then
  read LAST_BRANCH < ${last_branch_file}
else
  LAST_BRANCH=${branch_def}
fi

# while loop to ask again in case of empty branch name selected
while true; do
  ENTRY=`zenity --list --column="GitHub branches - ${repo} templates" "master" "${LAST_BRANCH}" "" ${MULTILINE} --height=300 --width=500 --title="GitHub branch selection"`
  case $? in
     0)
        if [ -z "${ENTRY}" ]; then
          zenity --warning --text="No branch name specified. Please, select again." --title="No branch name"  --width=200
          continue
        else
          branch=$ENTRY
        fi
        if [ -n "`git show-ref --verify refs/remotes/origin/"${branch}"`" ]; then
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
echo "branch set to ${branch}"

# shows the notification about the initiated task
notify-send -i software-update-available "${repo} repository" \
"<b>Repository (${branch} branch) reset started!</b> \
\rPlease wait till it is finished..."

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
  \r'git reset --hard "$branch"': \
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

# writes down small file that will hold the last used branch name
echo "$branch" > "$last_branch_file"

# ensure extract directory exists
mkdir -p "$extract_dir"

# unpack workflows safely
find "$directory" -type f \( -iname "*.zip" -o -iname "*.knwf" \) | while IFS= read -r file; do
  name=$(basename "$file" | sed 's/\.[^.]*$//')

  backup_dir="$extract_dir/.${name}.backup"
  error_dir="$extract_dir/.${name}.error"
  target_dir="$extract_dir/$name"
  
  # rename original folder
  rm -rf "$backup_dir"
  if [ -d "$target_dir" ]; then
    mv "$target_dir" "$backup_dir"
  fi
  rm -rf "$target_dir"
  
  unzip_return=$(unzip -o "$file" -d "$extract_dir" 2>&1)
  if [ $? != 0 ]; then
    # create a folder with failed unpacking, if a folder was created
    if [ -d "$target_dir" ]; then
      mv "$target_dir" "$error_dir"
    fi
    
    # if previous successful unpacking exists, restore
    if [ -d "$backup_dir" ]; then
      mv "$backup_dir" "$target_dir"
    fi
  
    notify-send -u critical -i dialog-error "${repo} repository" \
    "<b>Unzip failed!</b> \
    \rFile: $file \
    \r \
    \r${unzip_return}"
    exit 1
  fi
  
  # remove backup dir
  rm -rf "$backup_dir"

done

# shows the notification about the finished task
notify-send -u critical -i process-completed "${repo} repository" \
"<b>Repository (${branch} branch) reset completed!</b> \
\rYou can start to use them in KNIME! \
\rWorkspace refresh in KNIME may be needed! \
\rClick here to hide the notification"