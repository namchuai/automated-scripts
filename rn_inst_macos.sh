#!/bin/zsh

current_version=1.3.2 # Please increase me whenever you changed something
author="namh"

echo "============================================================"
echo "AUTOMATED REACT NATIVE INSTALLATION ON MACOS"
echo "VERSION: $current_version"
echo "AUTHOR: $author"
echo ""
echo "THIS SCRIPT ONLY WORKS ON LATEST MACOS VERSION"
echo ""
echo "============================================================"

# CHANGE_LOG
# - Install figma

install_home_brew()
{
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_jre_jdk()
{
  brew tap AdoptOpenJDK/openjdk
  brew install --cask adoptopenjdk8
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

install_visual_code()
{
  echo "INSTALLING visual code"
  brew install --cask visual-studio-code
}

### Check if already have brew or not
which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing HomeBrew.."
  install_home_brew
fi

### Yarn
readonly INSTALLED_BREW_PKG_FILE="installed_brew_pkgs"
readonly YARN_KEY="yarn"
brew list --formula > "$INSTALLED_BREW_PKG_FILE"

if ! grep -q "$YARN_KEY" "$INSTALLED_BREW_PKG_FILE" ; then
  echo "INSTALLING yarn.."
  brew install yarn
fi

### Check for java
readonly INSTALLED_BREW_CASK_PKG_FILE="installed_brew_cask_pkgs"
readonly JAVA_KEY="adoptopenjdk8"
brew list --cask > "$INSTALLED_BREW_CASK_PKG_FILE"

if ! grep -q "$JAVA_KEY" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  echo "INSTALLING OpenJDK 8.."
  install_jre_jdk
fi

### Check for visual code
readonly VS_CODE="visual-studio-code"
if ! grep -q "$VS_CODE" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  install_visual_code
fi

### Check if node is installed
which -s node
if [[ $? != 0 ]] ; then
  echo "INSTALLING node.."
  brew install node
fi

### Check if watchman is installed
which -s watchman
if [[ $? != 0 ]] ; then
  echo "INSTALLING watchan.."
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

ANDROID_HOME_PATH=$HOME/Library/Android/sdk

if ! grep -q "$TOKEN" "$ZSH_FILE" ; then
  echo "Exporting global env variables.."
  echo "$TOKEN" >> "$ZSH_FILE"
  echo "export ANDROID_HOME=$ANDROID_HOME_PATH" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME_PATH/emulator" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME_PATH/tools" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME_PATH/tools/bin" >> "$ZSH_FILE"
  echo "export PATH=$PATH:$ANDROID_HOME_PATH/platform-tools" >> "$ZSH_FILE"
fi

# Setting the git
echo "============================="
echo -n "Do you want to configure Git now? [y/n]"
read should_configure_git
if [ "$should_configure_git" = "y" ] ; then
  echo -n "Enter your Git name > "
  read git_name
  echo -n "Enter your Git email > "
  read git_email

  git config --global user.name "$git_name"
  git config --global user.email "$git_email"

  ssh-keygen

  echo "Your public key is:"
  cat ~/.ssh/id_rsa.pub
fi

install_google_chrome() {
  # Installing Google Chrome (optional)
  echo "============================="
  echo -n "Do you want to install Google Chrome? [y/n]"
  read should_install_chrome

  if [ "$should_install_chrome" = "y" ] ; then
    brew install --cask google-chrome
  fi
}

install_android_studio() {
  # Installing Android studio (optional)
  echo "============================="
  echo -n "Do you want to install Android studio? [y/n]"
  read should_install

  if [ "$should_install" = "y" ] ; then
    brew install --cask android-studio
  fi
}

GOOGLE_CHROME_KEY="google-chrome"
ANDROID_STUDIO_KEY="android-studio"
SLACK_KEY="slack"
WHATSAPP_KEY="whatsapp"
RN_DBG="react-native-debugger"
FIGMA="figma"

if ! grep -q "$GOOGLE_CHROME_KEY" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  install_google_chrome
fi

if ! grep -q "$ANDROID_STUDIO_KEY" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  install_android_studio
fi

if ! grep -q "$SLACK_KEY" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  brew install --cask slack
fi

if ! grep -q "$WHATSAPP_KEY" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  brew install --cask whatsapp
fi

if ! grep -q "$RN_DBG" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  brew install --cask "$RN_DBG"
fi

if ! grep -q "$FIGMA" "$INSTALLED_BREW_CASK_PKG_FILE"; then
  brew install --cask "$FIGMA"
fi

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Success! Please restart your terminal!"
