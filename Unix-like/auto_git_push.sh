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


# get temporary auto-push branch name to merge with the current auto-push branch
tmp_auto_branch="script/auto-push-$(date +"%Y%m%d_%H%M%S")"

# stash current changes
git stash push --message "savepoint_1"

# create a second reference to the same stashg
git stash apply
git stash push --message "savepoint_2"

# create branch based on stashed changes (switches to that branch automatically)
git stash branch "$tmp_auto_branch"

# create a "check" so we don't accidentally write over an important branch
cur_branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# exit if in a blacklisted set
[[ "$cur_branch" == "master" ]] && { echo "Cannot edit protected branch: $cur_branch" | tee -a /tmp/auto_git.log; exit 1; }
[[ "$cur_branch" == "main" ]] && { echo "Cannot edit protected branch: $cur_branch" | tee -a /tmp/auto_git.log; exit 1; }
[[ "$cur_branch" == "dev" ]] && { echo "Cannot edit protected branch: $cur_branch" | tee -a /tmp/auto_git.log; exit 1; }
[[ "$cur_branch" == "develop" ]] && { echo "Cannot edit protected branch: $cur_branch" | tee -a /tmp/auto_git.log; exit 1; }
[[ "$cur_branch" == "prod" ]] && { echo "Cannot edit protected branch: $cur_branch" | tee -a /tmp/auto_git.log; exit 1; }
[[ "$cur_branch" == "production" ]] && { echo "Cannot edit protected branch: $cur_branch" | tee -a /tmp/auto_git.log; exit 1; }

# add all of the changes
git add --all

# commit changes
git commit -m "Automatic commit"

# check to see if the script/auto-push branch exists upstream
git ls-remote --heads | grep "script/auto-push$" > /dev/null

# create the auto push branch
if [[ "$?" == "1" ]]; then
  # doesn't exist, create it
  git checkout -B "script/auto-push"
  git push --set-upstream origin script/auto-push
else
  git checkout "script/auto-push"
fi

# exit if not on the script/auto-push branch
cur_branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
[[ $cur_branch != "script/auto-push" ]] && { echo "Not in script/auto-push branch for some reason" | tee -a /tmp/auto_git.log; exit 1; }

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
