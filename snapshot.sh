#!/bin/sh

set -e

# Edit the settings to match your enviroiment

USER_LOGIN='user:xxxxxxxx'
# URL or IP address
URL='10.0.0.108' 
# Apsolute path to the main image directory
FILE_DIR='/media/img/'
# How many positions did you save in the camera?
POSITIONS=4

# End of settings. At this point there is no editing necessary
#
#

CONTROL_URL="http://$USER_LOGIN@$URL/web/cgi-bin/hi3510/preset.cgi?-act=goto&-number="
IMAGE_URL="http://$USER_LOGIN@$URL/tmpfs/snap.jpg"
DIR_NAME=`date '+%Y-%m-%d'`

CNT=0
# loop through the positions
while [ $CNT -lt $POSITIONS ]; do

    # Position directory does not exist. Create it
    POS_DIR=$FILE_DIR$CNT
    if [ ! -d $POS_DIR ]
    then
        mkdir $POS_DIR
    fi

    # Folder for today does not exist. Create it
    if [ ! -d $POS_DIR/$DIR_NAME ]
    then
        mkdir $POS_DIR/$DIR_NAME
    fi

    # move the camera to the position
    POSITION_URL="$CONTROL_URL$CNT"
    RES=`curl $POSITION_URL`

    # camera response is positive
    if [ "$RES" = "[Succeed]set ok." ]
    then
        # sleep 15 seconds to give the camera enough time
        # to move to the position and autofocus
        sleep 15
        IMAGE_NAME=`date '+%Y-%m-%d-%H-%M-%S'`.jpg
        curl $IMAGE_URL > $POS_DIR/$DIR_NAME/$IMAGE_NAME
        echo $IMAGE_URL
        echo $POS_DIR/$DIR_NAME/$IMAGE_NAME
    fi

    let CNT+=1

done