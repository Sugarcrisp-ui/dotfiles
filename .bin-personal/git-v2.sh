#!/bin/bash
#set -e

# This will run git in the local directory only

# Below command will backup everything inside the project folder
git add --all .

# Give a comment to the commit if you want
echo "####################################"
echo "Write your commit comment!"
echo "####################################"

read input

# Committing to the local repository with a message containing the time details and commit text

git commit -m "$input"

echo "################################################################"
echo "###################    Git Commit Done      ######################"
echo "################################################################"