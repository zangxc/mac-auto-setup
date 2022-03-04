#!/bin/bash
cat << EOS

 AkkeyLab

 The elapsed time does not matter.
 Because speed is important.

EOS

function command_exists {
  command -v "$1" > /dev/null;
}

#
# Copy git ssh config file
#
echo " ------- Git SSH config ------"
mkdir ~/.ssh && cp $(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/settings/git/config ~/.ssh/config
while true; do
  read -p 'Now git ssh settings? [Y/n]' Answer
  case $Answer in
    '' | [Yy]* )
      ssh-keygen -t rsa
      chmod 600 ~/.ssh/id_rsa
      eval `ssh-agent`
      ssh-add ~/.ssh/id_rsa
      ssh-add -l
      echo "Let’s register your public key on GitHub"
      echo "check command: `ssh -T git@github.com`"
      break;
      ;;
    [Nn]* )
      echo "Skip settings"
      break;
      ;;
    * )
      echo Please answer YES or NO.
  esac
done;
echo " ------------ END ------------"

#
# Memorize user pass
#
read -sp "Your Password: " pass;

#
# Mac App Store apps install
#
if ! command_exists mas ; then
  echo " ---- Mac App Store apps -----"
  brew install mas
  mas install 497799835  # Xcode
  echo " ------------ END ------------"
fi

#
# Install zsh
#
if ! command_exists zsh ; then
  echo " ------------ zsh ------------"
  brew install zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting colordiff
  which -a zsh
  echo $pass | sudo -S -- sh -c 'echo '/usr/local/bin/zsh' >> /etc/shells'
  chsh -s /usr/local/bin/zsh
  echo " ------------ END ------------"
fi

#
# Install vim
#
if ! command_exists vim ; then
  echo " ------------ Vim ------------"
  brew install vim --with-override-system-vi
  echo " ------------ END ------------"
fi

#
# Powerline
#
echo " --------- Powerline ---------"
# Font is 14pt Iconsolata for Powerline with Solarized Dark iterm2 colors.
# Recommend to 'Source Code Pro for Powerline'
brew install romkatv/powerlevel10k/powerlevel10k
git clone https://github.com/powerline/fonts.git ~/fonts
~/fonts/install.sh
echo " ------------ END ------------"

#
# Install ruby
#
if ! command_exists rbenv ; then
  echo " ----------- Ruby ------------"
  brew install rbenv
  brew install ruby-build
  rbenv --version
  rbenv install -l
  ruby_latest=$(rbenv install -l | grep -v '[a-z]' | tail -1 | sed 's/ //g')
  rbenv install $ruby_latest
  rbenv global $ruby_latest
  rbenv rehash
  ruby -v
  echo " ------------ END ------------"
fi

#
# Install dotfiles system
#
echo " ---------- dotfiles ---------"
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
cp $(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/settings/zsh/private.zsh ~/.yadr/zsh/private.zsh
source ~/.zshrc
echo " ------------ END ------------"

#
# gitmoji-cli
#
if ! command_exists gitmoji ; then
  echo " --------- gitmoji-cli ----------"
  brew install gitmoji
  echo " ------------ END ------------"
fi

read -p 'Please enter your Git User Name. You can skip by typing "N".' Answer
case $Answer in
  '' | [Nn]* )
    echo "Skip"
    ;;
  * )
    git config --global user.name $Answer
    git config user.name
    echo " ------------ END ------------"
esac

read -p 'Please enter your Git User e-mail. You can skip by typing "N".' Answer
case $Answer in
  '' | [Nn]* )
    echo "Skip"
    ;;
  * )
    git config --global user.email $Answer
    git config user.email
    echo " ------------ END ------------"
esac

read -p 'Please enter your GitHub Access Token. You can skip by typing "N".' Answer
case $Answer in
  '' | [Nn]* )
    echo "Skip"
    ;;
  * )
    echo "export GITHUB_ACCESS_TOKEN=${Answer}" >> ~/.yadr/zsh/private.zsh
    echo "export HOMEBREW_GITHUB_API_TOKEN=${Answer}" >> ~/.yadr/zsh/private.zsh
    echo "Writing to ~/.yadr/zsh/private.zsh is complete."
    echo " ------------ END ------------"
esac

read -p 'Install App Store apps. You can skip by typing "N".' Answer
case $Answer in
  '' | [Nn]* )
    echo "Skip"
    ;;
  * )
    $(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/appstore.sh
esac

read -p 'Install web apps. You can skip by typing "N".' Answer
case $Answer in
  '' | [Nn]* )
    echo "Skip"
    ;;
  * )
    $(cd $(dirname ${BASH_SOURCE:-$0}); pwd)/app.sh
esac
