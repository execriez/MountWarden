# MountWarden
![Logo](images/MountWarden.jpg "Logo")

Run custom code when a volume is mounted or umounted on MacOS.

## Description:

MountWarden catches MacOS mount events, to allow you to run custom code when a volume is mounted, is about to unmount, and when it is fully unmounted.

MountWarden consists of the following components:

	MountWarden              - The main binary that catches the volume mount events
	MountWarden-DidMount     - Called after a volume is mounted
	MountWarden-WillUnmount  - Called when a volume is about to unmount
	MountWarden-DidUnmount   - Called when a volume is fully unmounted
 
MountWarden-DidMount, MountWarden-UWillUnmount and MountWarden-DidUnmount are bash scripts.

The example scripts simply write to a log file in ~/Library/Logs. You should customise the scripts to your own needs.


## How to install:

Open the Terminal app, and download the latest [MountWarden.pkg](https://raw.githubusercontent.com/execriez/MountWarden/master/SupportFiles/MountWarden.pkg) installer to your desktop by typing the following command. 

	curl -k --silent --retry 3 --retry-max-time 6 --fail https://raw.githubusercontent.com/execriez/MountWarden/master/SupportFiles/MountWarden.pkg

To install, double-click the downloaded package.

The installer will install the following files and directories:

	/Library/LaunchAgents/com.github.execriez.mountwarden.plist
	/usr/MountWarden/
	/usr/MountWarden/bin/
	/usr/MountWarden/bin/MountWarden
	/usr/MountWarden/bin/MountWarden-DidMount
	/usr/MountWarden/bin/MountWarden-WillUnmount
	/usr/MountWarden/bin/MountWarden-DidUnmount

There's no need to reboot.

After installation, your computer will speak whenever a volume is mounted or unmounted. 

If the installer fails you should check the installation logs.

## Modifying the example scripts:

After installation, three simple example scripts can be found in the following location:

	/usr/MountWarden/bin/MountWarden-DidMount
	/usr/MountWarden/bin/MountWarden-WillUnmount
	/usr/MountWarden/bin/MountWarden-DidUnmount

These scripts simply write to the log file ~/Library/Logs/MountWarden.log whenever the ConsoleUser changes. Modify the scripts to your own needs.

**MountWarden-DidMount**

	#!/bin/bash
	#
	# Called by MountWarden as user like this:
	#   MountWarden-DidMount "DidMount:Epoch:VolumePath"
	# i.e.
	#   MountWarden-DidMount "DidMount:1538163950:/Volumes/MYFATDISK"
	
	# Get volume path
	sv_ThisVolumePath="$(echo ${1} | cut -d":" -f3)"
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') DidMount - '${sv_ThisVolumePath}' did mount" >> /tmp/MountWarden.log

**MountWarden-WillUnmount**

	#!/bin/bash
	#
	# Called by MountWarden as user like this:
	#   MountWarden-WillUnmount "WillUnmount:Epoch:VolumePath"
	
	# Get volume path
	sv_ThisVolumePath="$(echo ${1} | cut -d":" -f3)"
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') WillUnmount - '${sv_ThisVolumePath}' will unmount" >> /tmp/MountWarden.log

**MountWarden-DidUnmount**

	#!/bin/bash
	#
	# Called by MountWarden as user like this:
	#   MountWarden-DidUnmount "DidUnmount:Epoch:VolumePath"
	
	# Get volume path
	sv_ThisVolumePath="$(echo ${1} | cut -d":" -f3)"
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') DidUnmount - '${sv_ThisVolumePath}' did unmount" >> /tmp/MountWarden.log


## How to uninstall:

Open the Terminal app, and download the latest [MountWarden-Uninstaller.pkg](https://raw.githubusercontent.com/execriez/MountWarden/master/SupportFiles/MountWarden-Uninstaller.pkg) uninstaller to your desktop by typing the following command. 

	curl -k --silent --retry 3 --retry-max-time 6 --fail https://raw.githubusercontent.com/execriez/MountWarden/master/SupportFiles/MountWarden-Uninstaller.pkg --output ~/Desktop/ConsoleUserWarden-Uninstaller.pkg

To uninstall, double-click the downloaded package.

The uninstaller will remove the following files and directories:

	/Library/LaunchAgents/com.github.execriez.mountwarden.plist
	/usr/MountWarden/

After the uninstall everything goes back to normal, and volume mounting will not be tracked.

There's no need to reboot.

## Logs:

The example scripts write to the following log file:

	~/Library/Logs/MountWarden.log

The installer writes to the following log file:

	/Library/Logs/com.github.execriez.mountwarden.log
  
You should check this log if there are issues when installing.

## History:

1.0.3 - 02 MAY 2022

* Compiled as a fat binary to support both Apple Silicon and Intel Chipsets. This version requires MacOS 10.9 or later.

* The example scripts now just write to a log file. Previously they made use of the "say" command.

* The package creation and installation code has been aligned with other "Warden" projects.

1.0.2 - 07 OCT 2018

* Changed from a LaunchDaemon to a LaunchAgent, so that it runs as the user that mounted the drive, rather than as root.

1.0.1 - 28 SEP 2018

* First public release.

