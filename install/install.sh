# Output Formats: (http://misc.flogisoft.com/bash/tip_colors_and_formatting)


echo "\033[1m\033[35m"
echo "######################"
echo "#Installing DotFiles #"
echo "######################"
echo "\033[0m"


echo "Installing xcode-stuff"
xcode-select --install

echo " "
echo "Installing custom fonts (like Awesome-Terminal-Fonts)..."
cp fonts/* /Library/Fonts

echo " "
echo "Installing Zsh & Oh My Zsh..."
sh ~/.dotfiles/oh-my-zsh/tools/install.sh

echo "Setting ZSH as shell..."
chsh -s /bin/zsh


echo " "
echo "Installing HomeBrew..."
# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
	echo "HomeBrew not found -> installing..."
  	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating homebrew..."
brew update

echo "Installing homebrew cask"
brew install caskroom/cask/brew-cask


echo " "
echo "Install HomeBrew formulaes..."
sh ~/.dotfiles/install/brew.sh


echo " "
echo "Install MacOSX apps..."
sh ~/.dotfiles/install/apps.sh


echo " "
echo "Create all Symlinks..."
sh ~/.dotfiles/install/symlinks.sh


echo " "
echo "Setting some Mac settings..."
#Show directory path on Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
#Enable selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
#TODO: add more

killall Finder

echo "\033[1m\033[35m"
echo "Done!"