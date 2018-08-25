#!/sbin/sh
# --------------------------------
# SPLASH SELECTOR INSTALLER 1.0.0
# Created by @djb77
# --------------------------------

# Read option number from updater-script
OPTION=$1

# Variables
TGPTEMP=/tmp/tgptemp
AROMA=/tmp/aroma
BACKUP=/data/media/0/s.selector
SBLOCK=/dev/block/platform/11120000.ufs/by-name/UP_PARAM

if [ $OPTION == "setup" ]; then
	## Set Permissions
	chmod 755 $AROMA/tar
	chmod 755 $AROMA/s.selector.sh
	exit 10
fi

if [ $OPTION == "backup_check" ]; then
	## Config Check
	# If config backup is present, alert installer
	mount /dev/block/platform/11120000.ufs/by-name/USERDATA /data
	if [ -e $BACKUP/logo.png ]; then
		echo "install=1" > $AROMA/backup.prop
	fi
	exit 10
fi

if [ $OPTION == "check_g960x" ]; then
	echo "install=1" > $AROMA/g960x.prop
	exit 10
fi

if [ $OPTION == "check_g965x" ]; then
	echo "install=1" > $AROMA/g965x.prop
	exit 10
fi

if [ $OPTION == "backup" ]; then
	## Backup Checks
	# Check if s.selector folder exists on Internal Memory, if not, it is created
	if [ ! -d /data/media/0/s.selector ]; then
		mkdir /data/media/0/s.selector
		chmod 777 /data/media/0/s.selector
	fi
	# Check if config folder exists, if it does, delete it 
	if [ -d $BACKUP-backup ]; then
		rm -rf $BACKUP-backup
	fi
	# Check if config folder exists, if it does, ranme to backup
	if [ -d $BACKUP ]; then
		mv -f $BACKUP $BACKUP-backup
	fi
	# Check if config folder exists, if not, it is created
	if [ ! -d $BACKUP ]; then
		mkdir $BACKUP
		chmod 777 $BACKUP
	fi
	# Create Backup
	mkdir /tmp/splashtmp
	cd /tmp/splashtmp
	$AROMA/tar -xf $SBLOCK
	cp logo.jpg $BACKUP/logo.jpg
	if grep -q install=1 $AROMA/g960x.prop; then
		echo 960 > $BACKUP/device
	fi
	if grep -q install=1 $AROMA/g965x.prop; then
		echo 965 > $BACKUP/device
	fi
	rm -rf /tmp/splashtmp
	exit 10
fi

if [ $OPTION == "restore" ]; then
	# Device Check
	if grep -q install=1 $AROMA/g960x.prop; then
		if grep -q 960 $BACKUP/device; then
			echo "install=0" > $AROMA/backuperror.prop
			mkdir /tmp/splash
			cp $BACKUP/logo.jpg /tmp/splash/logo.jpg
		fi
	fi
	if grep -q install=1 $AROMA/g965x.prop; then
		if grep -q 965 $BACKUP/device; then
			echo "install=0" > $AROMA/backuperror.prop
			mkdir /tmp/splash
			cp $BACKUP/logo.jpg /tmp/splash/logo.jpg
		fi
	fi
	exit 10
fi

if [ $OPTION == "flash" ]; then
	# Flash Splash Screen
	mkdir /tmp/splashtmp
	cd /tmp/splashtmp
	$AROMA/tar -xf $SBLOCK
	cp /tmp/splash/logo.jpg .
	chown root:root *
	chmod 444 logo.jpg
	touch *
	$AROMA/tar -pcvf ../new.tar *
	cd ..
	cat new.tar > $SBLOCK
	cd /
	rm -rf /tmp/splashtmp
	rm -f /tmp/new.tar
	sync
	exit 10
fi

