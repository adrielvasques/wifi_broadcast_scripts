#!/bin/bash
# tx script

#if we detect no camera, we fall asleep
if vcgencmd get_camera | grep -q detected=0; then
	echo "tx.sh: Falling asleep because no camera has been detected"
	sleep 365d
fi


NIC="wlan1" #modifique aqui o nome do dispostivo 

#wait a bit. this helps automatic starting
sleep 2

source /home/pi/Desktop/wifibroadcast_fpv_scripts/settings.sh #modifique aqui com o caminho até o arquivo settings.sh


function prepare_nic {
	DRIVER=`cat /sys/class/net/$1/device/uevent | grep DRIVER | sed 's/DRIVER=//'`

	case $DRIVER in
		ath9k_htc)
			echo "Setting $1 to channel $CHANNEL2G"
			ifconfig $1 down
			iw dev $1 set monitor otherbss fcsfail
			ifconfig $1 up
			iw reg set BO # muda de região para ter controle da potência 
			iwconfig $1 txpower 20 # comando que altera frequência
			iwconfig $1 channel $CHANNEL2G
		;;
		*) echo "ERROR: Unknown wifi driver on $1: $DRIVER" && exit
		;;
	esac
}

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


prepare_nic $NIC

echo "Starting tx for $NIC"
raspivid -ih -t 0 -w $WIDTH -h $HEIGHT -fps $FPS -b $BITRATE -n -g $KEYFRAMERATE -pf high -o - | $WBC_PATH/tx -p $PORT -b $BLOCK_SIZE -r $FECS -f $PACKET_LENGTH $NIC > /dev/null

killall raspivid
killall tx
