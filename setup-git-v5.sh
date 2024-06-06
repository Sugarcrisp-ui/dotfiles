#!/bin/bash
#
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

project=$(basename `pwd`)
echo "-----------------------------------------------------------------------------"
echo "this is project https://github.com/Sugarcrisp-ui/"$project
echo "-----------------------------------------------------------------------------"
git config --global pull.rebase false
git config --global user.name "Brett Crisp"
git config --global user.email "brettcrisp2@gmail.com"
sudo git config --system core.editor micro
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=15778800'
git config --global push.default simple

# Check if SSH keys exist
if [ ! -f ~/.ssh/id_ed25519.pub ]; then
  echo "Generating new SSH key pair..."
  ssh-keygen -t ed25519 -C "brettcrisp2@gmail.com"
  echo "Add the following public key to your GitHub account:"
  cat ~/.ssh/id_ed25519.pub
  echo "Press Enter to continue..."
  read -p ""
else
  echo "SSH keys already exist."
fi

remote_url=$(git remote get-url origin)
if [ "$remote_url" != "git@github.com:Sugarcrisp-ui/$project" ]; then
  git remote set-url origin git@github.com:Sugarcrisp-ui/$project
  echo "Remote URL set to SSH."
else
  echo "Remote URL is already set correctly."
fi

echo "Everything set"

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
