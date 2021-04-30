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
git ls-remote --heads | grep "script/auto-push" > /dev/null

# checkout the auto push branch
if [[ "$?" == "1" ]]; then
  # doesn't exist, create it
  git checkout -b "script/auto-push"
  branch_exists="false"
else
  # just checkout
  git checkout "script/auto-push"
  branch_exists="true"
fi

# fetch any changes
git fetch && git pull

# add all of the changes
git add --all

# commit changes
git commit -m "Automatic commit"


if [[ "$branch_exists" == "false" ]]; then
  # doesn't exist, set upstream
  git push --set-upstream origin script/auto-push
elif [[ "$branch_exists" == "true" ]]; then
  # just push
  git push
else
  # error... exit
  echo "Error pushing branch script/auto-push in dir $gitdir" | tee -a /tmp/auto_git.log
  exit
fi

# switch back to the old branch if its different
if [[ $branch != "script/auto-push" ]]; then
  git checkout $branch;
  git fetch;
fi
