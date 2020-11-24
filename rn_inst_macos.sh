#!/bin/zsh
set -e
set -u

current_version=1.0 # Please increase me whenever you changed something
author="namh"

echo "============================================================"
echo "AUTOMATED REACT NATIVE INSTALLATION ON MACOS"
echo "VERSION: $current_version"
echo "AUTHOR: $author"
echo "============================================================"

install_home_brew()
{
	echo "INSTALLING HOMEBREW"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_node()
{
	echo "INSTALLING NODE"
	brew install node
}

install_watch_man()
{
	echo "INSTALLING WATCHMAN"
	brew install watchman
}

install_jre_jdk()
{
	echo "INSTALLING JRE, JDK 8"
	brew tap AdoptOpenJDK/openjdk
	brew cask install adoptopenjdk8
}

install_react_native()
{
    echo "INSTALLING React Native"	
	npm install -g react-native-cli
}

install_xcode_cli()
{
	echo "INSTALLING Xcode CLI"
	xcode-select -install
}

### Check if already have brew or not
which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing HomeBrew.."
    install_home_brew
fi

### Check for java
which -s java
if [[ $? != 0 ]]; then
  echo "Installing OpenJDK 8.."
  install_jre_jdk
fi

### Check if node is installed
which -s node
if [[ $? != 0 ]] ; then
	echo "Node does not installed"
	brew install node
fi

### Check if watchman is installed
which -s watchman
if [[ $? != 0 ]] ; then
	echo "Watchman does not installed"
	brew install watchman
fi

### List installed node modules
npm list -g --depth 0 > installed_node_pkgs

### Check if react-native-cli is installed
readonly INSTALLED_FILE="./installed_node_pkgs"
readonly RN_CLI="react-native-cli"

if ! grep -q "$RN_CLI" "$INSTALLED_FILE" ; then
	echo "Installing React Native cli.."
	npm install -g react-native-cli
fi

### Check if xcode cli is installed
xcode-select -p 1>/dev/null;echo $?
if [[ $? != 0 ]] ; then
	echo "Installing xcode cli.."
	xcode-select --install
fi

### Check if xcode cli is installed
gem list > installed_gems

readonly INSTALLED_GEM_FILE="./installed_gems"
readonly COCOAPODS="cocoapods"

if ! grep -q "$COCOAPODS" "$INSTALLED_GEM_FILE" ; then
	echo "Installing Cocoapods.."
	sudo gem install cocoapods
fi

### export env variable to zshrc
readonly ZSH_FILE="$HOME/.zshrc"
readonly TOKEN="# THIS IS AN AUTOMATED_TOKEN"

if [[ ! -e "$ZSH_FILE" ]]; then
  touch "$ZSH_FILE"
fi

if ! grep -q "$TOKEN" "$ZSH_FILE" ; then
  echo "Exporting global env variables.."
  echo "$TOKEN" >> "$ZSH_FILE"
  echo "export ANDROID_HOME=$HOME/Library/Android/sdk" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME/emulator" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOsME/tools" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME/tools/bin" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME/platform-tools" >> "$ZSH_FILE"
fi

echo "Success! Please restart your terminal!"
