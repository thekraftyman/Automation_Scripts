#!/bin/bash

# get the passed dir
gitdir=$1

# exit if the dir is empty
[[ -z "$gitdir" ]] && { echo "Recieved empty dir" | tee -a /tmp/auto_git.log; exit 1; }

# cd to dir
cd $gitdir

# check for git
[[ ! -d ".git" ]] && { echo "$gitdir not a git repo" | tee -a /tmp/auto_git.log; exit 1; }

# get current branch to switch back after
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# see if changes have been made and exit if not
if git diff-index --quiet HEAD --; then
  # no changes, exit
  exit 0
fi

# check to see if the script/auto-push branch exists upstream
git ls-remote --heads | grep "script/auto-push$" > /dev/null

# create the auto push branch
auto_branch_exists="true"
if [[ "$?" == "1" ]]; then
  # doesn't exist, create it
  git branch "script/auto-push"

  # set var to set upstream later
  auto_branch_exists="false"
fi

# get temporary auto-push branch name to merge with the current auto-push branch
tmp_auto_branch="script/auto-push-$(date +"%Y%m%d_%H%M%S")"

# stash current changes
git stash --message "savepoint_1"

# create a second reference to the same stashg
git stash apply
git stash push --message "savepoint_2"

# create branch based on stashed changes (switches to that branch automatically)
git stash branch "$tmp_auto_branch"

# add all of the changes
git add --all

# commit changes
git commit -m "Automatic commit"

# checkout the base script/auto-push branch
git checkout script/auto-push

# set script/auto-push upstream if it doesn't exist
if [[ "$branch_exists" == "false" ]]; then
  # doesn't exist, set upstream
  git push --set-upstream origin script/auto-push
fi

# merge the tmp auto-push into the real auto-push
#   uses a "theirs" strategy so everthing will get
#   overwritten if there are merge problems
git checkout --force
git pull
git merge -X theirs --message "merge tmp branch $tmp_auto_branch" "$tmp_auto_branch"
git push

# delete the tmp branch
git branch -d "$tmp_auto_branch"

# switch back to the old branch if its different
if [[ $branch != "script/auto-push" ]]; then
  git checkout $branch;
fi

# get the stashed changes
git stash pop

# fetch changes
git fetch
