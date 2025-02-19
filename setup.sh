#!/bin/bash
cat <<EOS

 AkkeyLab-zangxc-fork

 The elapsed time does not matter.
 Because speed is important.

EOS

function command_exists {
  command -v "$1" >/dev/null
}
FILE=~/.ssh/id_rsa
if [ -f "$FILE" ]; then
  echo "$FILE exists. Skipping ssh key creation."
else 
  echo "Creating an SSH key for you..."
  ssh-keygen -t rsa -b 4096
  ssh-keygen -t rsa
  chmod 600 ~/.ssh/id_rsa
fi
#
# Copy git ssh config file
#
echo " ------- Git SSH config ------"
mkdir ~/.ssh && cp $(
  cd $(dirname ${BASH_SOURCE:-$0})
  pwd
)/settings/git/config ~/.ssh/config
read -p 'Do you want to configure Git ssh ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  eval $(ssh-agent)
  ssh-add ~/.ssh/id_rsa
  ssh-add -l
  echo 'Let’s register your public key on GitHub\ncheck command: `ssh -T git@github.com`'
  ;;
esac
echo " ------------ END ------------"

#
# Memorize user pass
#
read -sp "Your Password: " pass

#
# Mac App Store apps install
#
if ! command_exists mas; then
  echo " ---- Mac App Store apps -----"
  brew install mas
  mas install 497799835 # Xcode
  echo " ------------ END ------------"
fi

#
# Install zsh
#
if [ ! -e "$(brew --prefix)/bin/zsh" ]; then
#   echo " ------------ zsh ------------"
#   brew install zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting colordiff
#   which -a zsh
#   echo $pass | sudo -S -- sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
#   # This is a workaround for problems that Xcode and others may refer to
#   echo $pass | sudo sh -c "mkdir -p /usr/local/bin & ln -s $(brew --prefix)/bin/zsh /usr/local/bin/zsh"
#   chsh -s "$(brew --prefix)/bin/zsh"
#   echo " ------------ END ------------"
#Install Zsh & Oh My Zsh
  echo "Installing Oh My ZSH..."
  curl -L http://install.ohmyz.sh | sh

  echo "Setting up Zsh plugins..."
  cd ~/.oh-my-zsh/custom/plugins
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

  echo "Setting ZSH as shell..."
  chsh -s /bin/zsh
fi

#
# Install vim
#
if ! command_exists vim; then
  echo " ------------ Vim ------------"
  brew install vim
  echo " ------------ END ------------"
fi

#
# Install dotfiles system
#
echo " ---------- dotfiles ---------"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh)"
cp $(
  cd $(dirname ${BASH_SOURCE:-$0})
  pwd
)/settings/zsh/private.zsh ~/.yadr/zsh/private.zsh
echo "typeset -U path PATH
path=(
  $(brew --prefix)/bin(N-/)
  $(brew --prefix)/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /Library/Apple/usr/bin
)
" >>~/.yadr/zsh/private.zsh
if [ -d /opt/homebrew/bin ]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.yadr/zsh/private.zsh
fi
source ~/.zshrc
echo " ------------ END ------------"

#
# Powerline
#
echo " --------- Powerline ---------"
# Font: MesloLGS NF Regular 13pt
# https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.yadr/zsh/private.zsh
cp $(
  cd $(dirname ${BASH_SOURCE:-$0})
  pwd
)/settings/zsh/p10k.zsh ~/.yadr/zsh/p10k.zsh
source ~/.zshrc
echo " ------------ END ------------"

#
# Install asdf
#
if ! command_exists asdf; then
  echo " ----------- asdf ------------"
  brew install asdf
  echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >>~/.yadr/zsh/private.zsh
  source ~/.zshrc
  echo " ------------ END ------------"
fi

#
# Install ruby
#
# if [ ! -e "$(echo ~$USERNAME)/.asdf/shims/ruby" ]; then
#   echo " ----------- Ruby ------------"
#   # No longer bundle 3rd party sources
#   # https://www.ruby-lang.org/en/news/2022/12/25/ruby-3-2-0-released
#   brew install libyaml ruby-build
#   echo -e "export RUBY_CONFIGURE_OPTS=\"--with-openssl-dir=$(brew --prefix openssl@1.1)\"" >>~/.yadr/zsh/private.zsh
#   source ~/.zshrc

#   asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
#   ruby_latest=$(asdf list all ruby | grep -v '[a-z]' | tail -1 | sed 's/ //g')
#   asdf install ruby $ruby_latest
#   asdf global ruby $ruby_latest
#   asdf reshim ruby
#   ruby -v
#   where ruby
#   asdf which ruby

#   # https://github.com/asdf-vm/asdf-ruby#migrating-from-another-ruby-version-manager
#   echo "legacy_version_file = yes" >~/.asdfrc
#   echo " ------------ END ------------"
# fi

# #
# # Install Golang
# #
# if [ ! -e "$(echo ~$USERNAME)/.asdf/shims/go" ]; then
#   echo " ---------- Golang -----------"
#   asdf plugin add golang https://github.com/kennyp/asdf-golang
#   golang_latest=$(asdf list all golang | grep -v '[a-z]' | tail -1 | sed 's/ //g')
#   asdf install golang $golang_latest
#   asdf global golang $golang_latest
#   asdf reshim golang
#   go version
#   where go
#   asdf which go

#   go install golang.org/x/tools/gopls@latest
#   go install github.com/go-delve/delve/cmd/dlv@latest
#   go install github.com/cweill/gotests/...@latest
#   asdf reshim golang

#   # GOPATH -> https://github.com/kennyp/asdf-golang/blob/master/bin/exec-env
#   # echo -e 'export GOPATH=$(asdf where golang)/go' >>~/.yadr/zsh/private.zsh
#   # echo -e 'export PATH="$PATH:$GOPATH"' >>~/.yadr/zsh/private.zsh
#   echo " ------------ END ------------"
# fi

#
# gitmoji-cli
#
if ! command_exists gitmoji; then
  echo " --------- gitmoji-cli ----------"
  brew install gitmoji
  echo " ------------ END ------------"
fi

#
# bat command
#
if ! command_exists bat; then
  echo " --------- bat command ----------"
  brew install bat
  echo " ------------ END ------------"
fi

read -p 'Do you want to enter your Git user name ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  read -p 'Git user name:' name
  git config --global user.name $name
  git config user.name
  echo " ------------ END ------------"
  ;;
esac

read -p 'Do you want to enter your Git user e-mail ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  read -p 'Git user e-mail:' mail
  git config --global user.email $mail
  git config user.email
  echo " ------------ END ------------"
  ;;
esac

read -p 'Do you want to enter your GitHub Access Token ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  read -p 'GitHub Access Token:' token
  echo "export GITHUB_ACCESS_TOKEN=${token}" >>~/.yadr/zsh/private.zsh
  echo "export HOMEBREW_GITHUB_API_TOKEN=${token}" >>~/.yadr/zsh/private.zsh
  echo "Writing to ~/.yadr/zsh/private.zsh is complete."
  source ~/.zshrc
  echo " ------------ END ------------"
  ;;
esac

read -p 'Do you want to install Google Cloud CLI ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  brew install --cask google-cloud-sdk
  echo "source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" >>~/.yadr/zsh/private.zsh
  echo "source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" >>~/.yadr/zsh/private.zsh
  source ~/.zshrc
  gcloud auth login
  ;;
esac

read -p 'Do you want to install App Store Apps ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  $(
    cd $(dirname ${BASH_SOURCE:-$0})
    pwd
  )/appstore.sh
  ;;
esac

read -p 'Do you want to install Third Party Apps ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  $(
    cd $(dirname ${BASH_SOURCE:-$0})
    pwd
  )/app.sh
  ;;
esac

read -p 'Would you like to create the recommended development directory ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  mkdir Development
  echo " ------------ END ------------"
  ;;
esac

#"Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

#"Showing icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

#"Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#"Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

#"Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle Clmv

#"Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

#"Setting the icon size of Dock items to 64 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 64

#"Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

#"Setting Dock to auto-hide and removing the auto-hiding delay"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

#"Disable 'natural' (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
