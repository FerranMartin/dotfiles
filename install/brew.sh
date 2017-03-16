echo " "
echo "Installing Git..."
brew install git
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
brew install terminal-notifier

echo " "
echo "Cleaning up brew"
brew cleanup
