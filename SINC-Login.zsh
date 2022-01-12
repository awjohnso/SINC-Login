#!/bin/zsh

# Author: Andrew W. Johnson
# Date: 2020.05.29.
# Version 2.50
# Organization: Stony Brook University/DoIT
#
# Many of the administrator settings were taken from: https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# Makes use of macos-brightness found at (https://github.com/mafredri/macos-brightness) installed in /usr/local/bin/
# Makes use of SwitchAudioSource found at (https://github.com/deweller/switchaudio-osx) installed in /usr/local/bin/

	# Variables for the executables needed.
dockutil="/usr/local/bin/dockutil"
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
desktoppr="/usr/local/bin/desktoppr"
myAdmin="admin"
myLog="/Users/Shared/$( /usr/bin/basename ${0} | /usr/bin/cut -d "." -f 1).log"

startCurtain ()
{
	${jamfHelper} -windowType fs -title "Account Setup" -heading "Computer Setup" -icon /usr/local/bin/sbicon.png -description "Your account is being setup and it will be available in a few seconds. Thank you for your patience." &
}

killCurtain ()
{
		# Kill the jamfHelper curtain.
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Getting rid of the curtain."  >> ${myLog}
	/bin/echo "Getting rid of the curtain."
	/bin/kill -9 $( /bin/ps -ax | /usr/bin/egrep -i jamfHelper | /usr/bin/egrep -iv grep | /usr/bin/awk '{print $1}' ) 2>/dev/null
}

/bin/echo "" >> ${myLog}
/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Starting $( /usr/bin/basename ${0} ), v2.50" >> ${myLog}
/bin/chmod 640 ${myLog}
/usr/bin/chflags -v hidden ${myLog}
/bin/chmod -v 666 ${myLog}

#myFinder=$( /bin/ps -ax | /usr/bin/egrep Finder.app | /usr/bin/egrep -vc egrep )
myFinder=$( /usr/bin/pgrep -x Finder )
while [[ ${myFinder} -eq 0 ]]; do
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]:Waiting for Finder." >> ${myLog}
	/bin/echo "Waiting for Finder."
	sleep 0.5
	myFinder=$( /usr/bin/pgrep -x Finder )
#	myFinder=$( /bin/ps -ax | /usr/bin/egrep Finder.app | /usr/bin/egrep -vc egrep )
done

/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Finder is up." >> ${myLog}
/bin/echo "Finder is up."

	# Get the user logging in.
myUser=$( /usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }' )

	# Wait for the user to be logged in, try 15 times.
n=0
while [[ -z ${myUser} ]]; do
        /bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: No user specified." >> ${myLog}
        /bin/echo "No user specified."
        sleep 0.5
        let n=${n}+1
        myUser=$( /usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }' )
        /bin/echo "Loop ${n}"
        if [ ${n} -ge 15 ]; then
			break
        fi
done
/bin/echo "${myUser}"
/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myUser}" >> ${myLog}

	# Get the location of the home directory for the user logging in.
myHome=$( /usr/bin/dscl . read /Users/${myUser} home 2>/dev/null | /usr/bin/awk '{print $2}' )
/bin/echo "${myHome}"
/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myHome}" >> ${myLog}
	# Wait for the user home directory to be available, try 15 times.
n=0
while [[ ! -d ${myHome} ]]; do
        /bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: No home found." >> ${myLog}
        /bin/echo "No home found."
        sleep 0.5
        let n=${n}+1
        if [ ${n} -ge 15 ]; then
			break
        fi
done

#########################################################################################
#                                                                                       #
#                   !!! Local Administrator Settings go Here !!!                        #
#                                                                                       #
#########################################################################################
#                                                                                       #
# Since usually the local admninistrator is going to disable MCX/Configuration Profiles #
# We need to manully set some of the settings up at login.                              #
#                                                                                       #
#########################################################################################

if [ ${myUser} = "${myAdmin}" ]; then
	/bin/echo "Local administrator ${myUser} is logging in."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Local administrator ${myUser} is logging in." >> ${myLog}
		# Make the admin dir invisible & change permissions.
	/bin/echo "Hiding home directory."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Hiding home directory." >> ${myLog}
	/usr/bin/chflags -v hidden ${myHome}
	/bin/echo "Changing permissions on the home directory."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Changing permissions on the home directory." >> ${myLog}
	/bin/chmod -v 700 ${myHome} 2>/dev/null
		
		# Set sidebar icon size to medium
	/bin/echo "Set sidebar icon size to small."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Set sidebar icon size to small." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain NSTableView/usr/bin/defaultsizeMode -int 1

		# Expand save panel by default
	/bin/echo "Expand save panel by default."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Expand save panel by default." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

		# Expand print panel by default
	/bin/echo "Expand print panel by default."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Expand print panel by default." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

		# Save to disk (not to iCloud) by default
	/bin/echo "Save to disk (not to iCloud) by default."
 	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Save to disk (not to iCloud) by default." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;

		# Automatically quit printer app once the print jobs complete
	/bin/echo "Automatically quit printer app once the print jobs complete."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Automatically quit printer app once the print jobs complete." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true;

		# Disable the "Are you sure you want to open this application?" dialog
	/bin/echo "Disable the \"Are you sure you want to open this application?\" dialog."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Disable the \"Are you sure you want to open this application?\" dialog." >> ${myLog}
	/usr/bin/defaults write com.apple.LaunchServices LSQuarantine -bool false

		# Disable "natural" (Lion-style) scrolling
	/bin/echo "Disable \"natural\" (Lion-style) scrolling."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Disable \"natural\" (Lion-style) scrolling." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

		# Finder: show status bar
	/bin/echo "Finder: show status bar."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Finder: show status bar." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder ShowStatusBar -bool true

		# Finder: show path bar
	/bin/echo "Finder: show path bar."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Finder: show path bar." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder ShowPathbar -bool true

		# Avoid creating .DS_Store files on network volumes
	/bin/echo "Avoid creating .DS_Store files on network volumes."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Avoid creating .DS_Store files on network volumes." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

		# Prevent Time Machine from prompting to use new hard drives as backup volume
	/bin/echo "Prevent Time Machine from prompting to use new hard drives as backup volume."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Prevent Time Machine from prompting to use new hard drives as backup volume." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

		# Enable spring loading for directories
	/bin/echo "Enable spring loading for directories."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Enable spring loading for directories." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write NSGlobalDomain com.apple.springing.enabled -bool true

		# Use the system-native print preview dialog
	/bin/echo "Use the system-native print preview dialog."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Use the system-native print preview dialog." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.google.Chrome DisablePrintPreview -bool true
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.google.Chrome.canary DisablePrintPreview -bool true

		# Set Desktop as the default location for new Finder windows
		# For other paths, use `PfLo` and `file:///full/path/here/`
	/bin/echo "Set Desktop as the default location for new Finder windows."
 	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Set Desktop as the default location for new Finder windows." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder NewWindowTarget -string "PfDe"
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

		# Show icons for hard drives, servers, and removable media on the desktop
	/bin/echo "Show icons for hard drives, servers, and removable media on the desktop."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Show icons for hard drives, servers, and removable media on the desktop." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

		# Use icon view in all Finder windows by default
		# Four-letter codes for the other view modes: `Nlsv`, `clmv`, `Flwv`
	/bin/echo "Use icon view in all Finder windows by default."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Use icon view in all Finder windows by default." >> ${myLog}
	/usr/bin/sudo -u ${myUser} /usr/bin/defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

		# Disable Resume system-wide
	/bin/echo "Disable Resume system-wide."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Disable Resume system-wide." >> ${myLog}
	/usr/bin/defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

		# Disable Notification Center and remove the menu bar icon
	/bin/echo "Disable Notification Center and remove the menu bar icon."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Disable Notification Center and remove the menu bar icon." >> ${myLog}
	/bin/launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

		# Disable local Time Machine backups
#	/bin/echo "Disable local Time Machine backups."
# 	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Disable local Time Machine backups." >> ${myLog}
#	/usr/bin/hash tmutil &> /dev/null && sudo tmutil disable
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Configuring the Dock." >> ${myLog}
	/bin/echo "Configuring the Dock."

		# If the executable dockutil is not installed warn with an echo statement.
	if [ ! -e ${dockutil} ]; then
		/bin/echo "Please install dockutil."
 		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Please install dockutil." >> ${myLog}
	else
			# Applications go here!
		${dockutil} -v --remove all --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Applications/Utilities/Activity Monitor.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/Applications/BBEdit.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Applications/Utilities/Console.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Library/CoreServices/Applications/Directory Utility.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Applications/Utilities/Disk Utility.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/Applications/Google Chrome.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Library/CoreServices/Applications/Network Utility.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/Applications/Safari.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Applications/System Preferences.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/Applications/Self Service.app" --no-restart ${myHome} >> ${myLog}
		${dockutil} -v --add "/System/Applications/Utilities/Terminal.app" ${myHome} >> ${myLog}
	fi

		# Don't show recent applications and turn on magnification in Dock.
	/bin/echo "Don't show recent applications in Dock and turn on magnification."
 	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Don't show recent applications in Dock and turn on magnification" >> ${myLog}

	/usr/bin/defaults write ${myHome}/Library/Preferences/com.apple.dock magnification -bool true
	/usr/bin/defaults write ${myHome}/Library/Preferences/com.apple.dock show-recents -bool false
		# Relead the preferences.
	/usr/bin/killall cfprefsd	
	
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Sleep 2"  >> ${myLog}
	/bin/echo "Sleep 2"
	sleep 2

		# If the executable desktoppr is not installed warn with an echo statement.
	if  [ ! -e ${desktoppr} ]; then
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Please install desktoppr." >> ${myLog}
		/bin/echo " Please install desktoppr."
	else
    	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting the desktop to /Library/Desktop Pictures/SBUBlack.png." >> ${myLog}
		/bin/echo "Setting the desktop to /Library/Desktop Pictures/SBUBlack.png"
			# Set the desktop to the SBUBlack background.
		${desktoppr} "/Library/Desktop Pictures/SBUBlack.png"
		${desktoppr} scale stretch
	fi
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Sleep 2"  >> ${myLog}
	/bin/echo "Sleep 2"
	sleep 2

else

#########################################################################################
#                                                                                       #
#                    !!! Non admin users settings goes here. !!!!                       #
#                                                                                       #
#########################################################################################

	/bin/echo "Non admin users logging in."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Non admin users logging in." >> ${myLog}
    
		# Create and block the Users LaunchAgents directory.
	if [ ! -d "${myHome}/Library/LaunchAgents" ]; then
		/bin/mkdir -v ${myHome}/Library/LaunchAgents
		/bin/echo "Blocking ${myHome}/Library/LaunchAgents."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Blocking ${myHome}/Library/LaunchAgents." >> ${myLog}
		/bin/chmod 000 ${myHome}/Library/LaunchAgents
	fi
	
		# Change the end user home directory so no one else can look in but the user.
	/bin/chmod -v 700 ${myHome} 2>/dev/null

		# If SwitchAudioSource is installed then...
	if [ -e "/usr/local/bin/SwitchAudioSource" ]; then
			# if the Scarlett 2i2 USB is installed use it as the audio input and output.
		myScarlett=$(/usr/local/bin/SwitchAudioSource -a | /usr/bin/egrep -ic scarlett)
		if [ ${myScarlett} -ge 1 ]; then
			/bin/echo "Found Scarlett 2i2 USB."
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Found Scarlett 2i2 USB." >> ${myLog}
			myResult=$(/usr/local/bin/SwitchAudioSource -t system -i $(/usr/local/bin/SwitchAudioSource -a -f cli | /usr/bin/grep -i "Built-in Output" | /usr/bin/grep -i output | /usr/bin/cut -d "," -f 3))
			/bin/echo "${myResult}"
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
			myResult=$(/usr/local/bin/SwitchAudioSource -t input -i $(/usr/local/bin/SwitchAudioSource -a -f cli | /usr/bin/grep -i scarlett | /usr/bin/grep -i input | /usr/bin/cut -d "," -f 3))
			/bin/echo "${myResult}"
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
			myResult=$(/usr/local/bin/SwitchAudioSource -t output -i $(/usr/local/bin/SwitchAudioSource -a -f cli | /usr/bin/grep -i scarlett | /usr/bin/grep -i input | /usr/bin/cut -d "," -f 3))
			/bin/echo "${myResult}"
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
		else
				# Use the system audio for input and output.
			/bin/echo "No Scarlett 2i2 USB found."
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: No Scarlett 2i2 USB found." >> ${myLog}
			myResult=$(/usr/local/bin/SwitchAudioSource -t system -i $(/usr/local/bin/SwitchAudioSource -a -f cli | /usr/bin/grep -i "Built-in Output" | /usr/bin/grep -i output | /usr/bin/cut -d "," -f 3))
			/bin/echo "${myResult}"
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
			myResult=$(/usr/local/bin/SwitchAudioSource -t input -i $(/usr/local/bin/SwitchAudioSource -a -f cli | /usr/bin/grep -i "Built-in Microphone" | /usr/bin/grep -i input | /usr/bin/cut -d "," -f 3))
			/bin/echo "${myResult}"
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
			myResult=$(/usr/local/bin/SwitchAudioSource -t output -i $(/usr/local/bin/SwitchAudioSource -a -f cli | /usr/bin/grep -i "Built-in Output" | /usr/bin/grep -i output | /usr/bin/cut -d "," -f 3))
			/bin/echo "${myResult}"
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
		fi
	fi
		# Set the volume to 6.
	/bin/echo "Setting the audio volume to 6."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting the audio volume to 6." >> ${myLog}
	/usr/bin/osascript -e "set volume 6"

		# If the Google updater launchagent is present remove it.
	if [ -e "${myHome}/Library/LaunchAgents/com.google.keystone.agent.plist" ]; then
		/bin/echo "Removing ${myHome}/Library/LaunchAgents/com.google.keystone.agent.plist"
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Removing ${myHome}/Library/LaunchAgents/com.google.keystone.agent.plist" >> ${myLog}
		/bin/rm -f ${myHome}/Library/LaunchAgents/com.google.keystone.agent.plist
	fi
	
		# If the Google softwareupdate bundle is present get rid of it and prevent it from coming back.
	if [ -d "${myHome}/Library/Google/GoogleSoftwareUpdate" ]; then
		/bin/echo "Removing the GoogleSoftwareUpdate.bundle."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Removing the GoogleSoftwareUpdate.bundle." >> ${myLog}
		/bin/rm -Rf ${myHome}/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle
		/bin/mkdir -p ${myHome}/Library/Google/GoogleSoftwareUpdate
		/usr/bin/touch ${myHome}/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle
		/usr/sbin/chown root ${myHome}/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle
		/bin/chmod 644 ${myHome}/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle
	fi
	
		# If $HOME/Library/Printers exits, get rid of it and link to /Library/Printers/Installed_Printers.
	if [ -d "${myHome}/Library/Printers" ]; then
		/bin/echo "Fixing the printer issue."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Fixing the printer issue." >> ${myLog}
		/bin/rm -rf ${myHome}/Library/Printers/
		/bin/ln -s /Library/Printers/Installed_Printers ${myHome}/Library/Printers 2>/dev/null
	fi

		# Reload the preferences.
	/usr/bin/killall cfprefs 2>/dev/null

		# Consult sign-in stuff.
	if  [ ${myUser} = "sincconsult" ]; then

		if [ -d "/usr/local/Applications/Consultant Sign-in.app" ]; then
			/bin/echo "Consultant logging in. Ensuring alias to sign-in app is in place."
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Consultant logging in. Ensuring alias to sign-in app is in place." >> ${myLog}
			/usr/local/bin/alisma -a "/usr/local/Applications/Consultant Sign-in.app" "/Users/sincconsult/Desktop/SubItUp Timeclock"
		else
			/bin/echo "Consultant sign-in app is not available on this computer."
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Consultant sign-in app is not available on this computer." >> ${myLog}
		fi
	else
		/bin/echo "Not a consultant user."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Not a consultant user." >> ${myLog}
	fi
		# Set the screeensaver message depending on the lab the computer belongs to.
	myClassrooms=(fam \
					hyb \
					thr \
					llm \
	)
		# Get my computer name and grab just the first three letters. Issue in grad labs??
	myCompName=$( /usr/sbin/networksetup -getcomputername | /usr/bin/cut -c 1-3 | /usr/bin/tr '[:upper:]' '[:lower:]' )
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myCompName}" >> ${myLog}
	/bin/echo "${myCompName}"
		# Get the UUID of the Macintosh to then operate on the ByHost preference.
	myUUID=$( /usr/sbin/ioreg -d2 -c IOPlatformExpertDevice | /usr/bin/egrep -i IOPlatformUUID | /usr/bin/sed s/\"//g | /usr/bin/awk -F " = " '{print $2}' )
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myUUID}" >> ${myLog}
	/bin/echo "${myUUID}"
		# Build the path to the plist
	myPLIST="${myHome}/Library/Containers/com.apple.ScreenSaver.Computer-Name/Data/Library/Preferences/ByHost/com.apple.ScreenSaver.Computer-Name.${myUUID}.plist"
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myPLIST}" >> ${myLog}
	/bin/echo "${myPLIST}"
	if [ ! -d "${myHome}/Library/Containers/com.apple.ScreenSaver.Computer-Name/Data/Library/Preferences/ByHost" ]; then
		/bin/mkdir -p ${myHome}/Library/Containers/com.apple.ScreenSaver.Computer-Name/Data/Library/Preferences/ByHost
		/bin/chmod 700 ${myHome}/Library/Containers/com.apple.ScreenSaver.Computer-Name/Data/Library/Preferences/ByHost
	fi
		# Create the message.
	isClass=0
	for i in "${myClassrooms[@]}"; do
		if [ $( /bin/echo -n ${i} | /usr/bin/egrep -iwc ${myCompName} ) -ge 1 ]; then
			isClass=1
		fi
	done
	if [ ${isClass} -eq 1 ]; then
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: SINC Classroom Computer." >> ${myLog}
		/bin/echo "SINC Classroom Computer."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting Screensaver msg to 10 minutes for classroom computers." >> ${myLog}
		/bin/echo "Setting Screensaver msg to 10 minutes for classroom computers."
		/usr/libexec/PlistBuddy -c 'Delete :MESSAGE' ${myPLIST} 2>/dev/null
		/usr/libexec/PlistBuddy -c 'Add :MESSAGE string You will be logged out in less than 10 minutes\!' ${myPLIST}
 	else
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: SINC Lab Computer." >> ${myLog}
		/bin/echo "SINC Lab Computer."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting Screensaver msg to 5 minutes for SINC computers." >> ${myLog}
		/bin/echo "Setting Screensaver msg to 5 minutes for SINC computers."
		/usr/libexec/PlistBuddy -c 'Delete :MESSAGE' ${myPLIST} 2>/dev/null
		/usr/libexec/PlistBuddy -c 'Add :MESSAGE string You will be logged out in less than 5 minutes\!' ${myPLIST}
	fi
fi

#########################################################################################
# !!! Settings for all users starts here. !!!!                                          #
#########################################################################################

	# Set the brightness if it's an iMac and the executable is installed.
if [ -e "/usr/local/bin/brightness" ]; then
		# Find machine type to set the brightness on the iMacs.
	compType=$( /usr/sbin/sysctl -n hw.model | /usr/bin/cut -c 1-4 )
		# If type is iMac set the brightness.
	if  [ ${compType} = "iMac" ]; then
		/bin/echo "This computer is an iMac. Setting brightness to 100"
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: This computer is an iMac. Setting brightness to 100" >> ${myLog}
		/usr/local/bin/brightness -b 100
	else
		/bin/echo "This computer is not an iMac."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: This computer is not an iMac." >> ${myLog}
	fi
else
	/bin/echo "I can not find /usr/local/bin/brightness."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: I can't find /usr/local/bin/brightness." >> ${myLog}
fi

	# SINC Login Tracker.
compName=$( /usr/sbin/networksetup -getcomputername )
	# Curl the data up to the web site.
myResult=$( /usr/bin/curl -s -X POST -F Username=${myUser} -F ComputerName=${compName} https://my.university.edu/api/login/create )
/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myResult}" >> ${myLog}
/bin/echo "${myResult}"

/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Ending $( /usr/bin/basename ${0} ), v2.50" >> ${myLog}

exit 0
