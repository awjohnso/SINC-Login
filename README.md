# SINC-Login
 Login Scripts for our lab computers.


- Author: Andrew W. Johnson
- Date: 2020.05.29.
- Version 2.50
- Organization: Stony Brook University/DoIT
---
Many of the administrator settings were taken from: https://github.com/mathiasbynens/dotfiles/blob/master/.macos

Makes use of
- macos-brightness found at https://github.com/mafredri/macos-brightness installed in /usr/local/bin/.
- SwitchAudioSource found at https://github.com/deweller/switchaudio-osx installed in /usr/local/bin/.
- desktoppr found at https://github.com/scriptingosx/desktoppr installed in /usr/local/bin/.
- dockutil found at: https://github.com/kcrawford/dockutil installed in /usr/local/bin/.
- alisma found at: https://eclecticlight.co/taccy-signet-precize-alifix-utiutility-alisma/ installed in /usr/local/bin/.

### Version 2.5
Deprecated the use of the Jamf curtain but kept the ability do so as a function in case it's needed again in the future. Fixed the Audio switching by moving over to SwitchAudioSource. Got rid of the Dock and desktop background settings for the end user as that is now managed again by profiles.

### Local Administrator Settings
Uses defaults to set the following settings because local admins tend to disable Managed Settings when logging in:
- Make the admin dir invisible & change permissions.
- Set sidebar icon size to medium.
- Expand save panel by default.
- Expand print panel by default.
- Save to disk (not to iCloud) by default.
- Automatically quit printer app once the print jobs complete.
- Disable the "Are you sure you want to open this application?" dialog.
- Disable "natural" (Lion-style) scrolling.
- Finder: show path bar.
- Avoid creating .DS_Store files on network volumes.
- Prevent Time Machine from prompting to use new hard drives as backup volume
- Enable spring loading for directories
- Use the system-native print preview dialog.
- Set Desktop as the default location for new Finder windows PfDe. For other paths, use PfLo and file:///full/path/here/.
- Show icons for hard drives, servers, and removable media on the desktop.
- Use icon view in all Finder windows by default. Four-letter codes for the  view modes: icnv, Nlsv, clmv, Flwv.
- Disable Resume system-wide.
- Disable Notification Center and remove the menu bar icon.
- Configure the Dock with dockutil.
- Don't show recent applications and turn on magnification in the Dock.
- Set the desktop background with desktoppr, and scale it to stretch.

### End User Settings
Most settings are managed throught profiles.
- Create and block the user logging in LaunchAgents directory.
- Change the end user home directory so no one else can look in but the user.
- If SwitchAudioSource is installed and the Scarlett 2i2 USB is attached, then set sound in and out to the device, and system sounds to the internal speakers. If not set all sounds to the internal speaker.
- Set the volume to 6.
- If the Google updater launchagent is present remove it.
- If the Google softwareupdate bundle is present get rid of it and prevent it from coming back.
- If $HOME/Library/Printers exits, get rid of it and link to /Library/Printers/Installed_Printers.

### Student Consultant
When our student consultatants sign in with the special account do the following:
- If the shift sign-in app is available use alisma to create an alias to the desktop.

### For All users
Settings that are universal for all users
- Set the screensaver Compuer-Name's message depending on the computer name.
- If the computer is an iMac use the app brightness to set the brightness at 100%.
- Push user tracking data to our tracking server.
