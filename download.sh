#!/bin/bash
cat <<EOS

 AkkeyLab

 The elapsed time does not matter.
 Because speed is important.

EOS

function command_exists {
  command -v "$1" >/dev/null
}

#
# Install homebrew.
#
if ! command_exists brew; then
  echo " --------- Homebrew ----------"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  source ~/.zprofile
  brew -v
  echo " ------------ END ------------"
fi

#
# Install git
#
if [ ! -e "$(brew --prefix)/bin/git" ]; then
  echo " ------------ Git ------------"
  brew install git
  brew info git
  git --version
  echo " ------------ END ------------"
fi

#
# mac-auto-setup.git
#
echo " ---- mac-auto-setup.git -----"
git clone https://github.com/zangxc/mac-auto-setup.git
echo " ------------ END ------------"
