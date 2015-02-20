# Apps
apps=(
 alfred
 firefox
 steam
 hipchat
 qlstephen
 cleanmymac
 licecap
 sequel-pro
 virtualbox
 mou
 skype
 vlc
 diffmerge
 sourcetree
 dropbox
 spotify
 sublime-text
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo ""
echo "Installing apps with Cask..."
brew cask install --appdir="/Applications" ${apps[@]}

brew cask alfred link

brew cask cleanup
brew cleanup