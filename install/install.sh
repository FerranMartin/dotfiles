# Output Formats: (http://misc.flogisoft.com/bash/tip_colors_and_formatting)


echo "\033[1m\033[35m"
echo "######################"
echo "#Installing DotFiles #"
echo "######################"
echo "\033[0m"


echo "Installing xcode-stuff"
xcode-select --install

echo " "
echo "Installing HomeBrew..."
# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
	echo "HomeBrew not found -> installing..."
  	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo " "
echo "Installing Git..."
brew install git

echo "Git config"
git config --global user.name "Ferran Martin"
git config --global user.email ferran@ferranmartins.es

echo "Installing brew git utilities..."
brew install git-extras
brew install legit
brew install git-flow

echo " "
echo "Installing other brew stuff..."
brew install tig
brew install tree
brew install wget
brew install trash
brew install svn
brew install node
brew install cowsay
brew install fortune

echo " "
echo "Cleaning up brew"
brew cleanup

echo " "
echo "Installing homebrew cask"
brew install caskroom/cask/brew-cask


# Install MacOSX apps
sh apps.sh


#Install Oh My ZSH
#Install Zsh & Oh My Zsh
echo " "
echo "Installing Oh My ZSH..."
sh oh-my-zsh/tools/install.sh

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

echo " "
echo "Setting some Mac settings..."
#TODO

killall Finder

echo "\033[1m\033[35m"
echo "Done!"