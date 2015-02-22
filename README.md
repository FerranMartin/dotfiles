```
      ██            ██     ████ ██  ██
     ░██           ░██    ░██░ ░░  ░██
     ░██  ██████  ██████ ██████ ██ ░██  █████   ██████
  ██████ ██░░░░██░░░██░ ░░░██░ ░██ ░██ ██░░░██ ██░░░░
 ██░░░██░██   ░██  ░██    ░██  ░██ ░██░███████░░█████
░██  ░██░██   ░██  ░██    ░██  ░██ ░██░██░░░░  ░░░░░██
░░██████░░██████   ░░██   ░██  ░██ ███░░██████ ██████
 ░░░░░░  ░░░░░░     ░░    ░░   ░░ ░░░  ░░░░░░ ░░░░░░

```
![](http://gifsb.in/codes/floppy-discs.gif)

# FerranMartin dotfiles
My personal dotfiles :)

## Install
Run this:

```
$ git clone https://github.com/FerranMartin/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
$ sh install/install.sh
```

##Contents

* **`install/`** Scripts to install all. Contains:
 	* **`install.sh`** to install and configure all _(xcode-stuff, homebrew, git, zsh, set of brew stuff, set of mac apps, etc)_. This script use the follow scripts
	* `apps.sh` to install a list of basic MacOSX apps
	* `symlinks.sh` to create all symlinks from *[dotfiles](./dotfiles)*
* **`dotfiles/`** folder with all configuration files to create the symlinks. Contains:
	* `vimrc` Vim settings.
	* `zshrc` [Zsh](http://www.zsh.org/) & [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) settings.
	* `gitconfig` global *Git* configurations.
	* `gitignore_global` A global *gitignore* configuration.
* **`oh-my-zsh/`** Submodule checkout of [Oh My Zsh](https://	github.com/robbyrussell/oh-my-zsh).
* **`README.md`** This file ;)


## Thanks

I take the [Brad Parbs dotfiles repo](https://github.com/bradp/dotfiles) and his [Blog post](http://webdevstudios.com/2015/02/10/a-beginners-guide-to-the-best-command-line-tools/) as an example to start with my dotfiles ;) 

_(I realy love the initial gif XD)_
