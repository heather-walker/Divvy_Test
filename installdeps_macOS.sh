#ECHO
read -r -p 'Do you have homebrew installed? ' HAS_BREW
if [ "$HAS_BREW" = 'yes' ]
then
   ECHO 'Installing dependencies...'
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
# Installing jq
ECHO
ECHO 'Installing dependencies...'
brew install jq
ECHO
ECHO 'Install complete.'