#!/bin/bash
cat <<EOS

 AkkeyLab-zangxc-fork

 The elapsed time does not matter.
 Because speed is important.

EOS

#
# Install web apps.
#
echo " ----- Install web apps ------"
sudo softwareupdate --install-rosetta

brew install --cask keepassxc
brew tap AdoptOpenJDK/openjdk
brew install --cask adoptopenjdk
# brew install --cask android-studio
brew install --cask docker
brew install --cask google-chrome
brew install --cask iterm2
# brew install --cask google-japanese-ime
brew install --cask slack
# brew install --cask spotify
# brew install --cask imageoptim
brew install --cask visual-studio-code
# brew install --cask adobe-creative-cloud
brew install --cask gyazo
brew install --cask zoom
# brew install --cask discord
brew install --cask notion
# brew install --cask figma
# brew install --cask tableplus
# brew install --cask postman
brew install --cask clipy
brew install --cask alfred
brew install --cask sublime-text2
brew install --cask karabiner-elements
brew install python

read -p 'Do you want to install license need apps ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
#   brew install --cask microsoft-office
#   brew install --cask intellij-idea
#   brew install --cask clip-studio-paint
  ;;
esac
