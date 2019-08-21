#ECHO
read -r -p 'Do you have chocolatey NuGet installed? ' HAS_CHOCO
if [ "$HAS_CHOCO" = 'yes' ]
then
   ECHO 'Installing dependencies...'
   @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
fi
# Installing jq
ECHO
ECHO 'Installing dependencies...'
chocolatey install jq