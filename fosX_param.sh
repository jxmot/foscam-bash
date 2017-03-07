#!/usr/bin/env bash

# name this file as - 
# cameraname_param.sh
#
# where 'cameraname' represents an easy to remember and
# associate camera name. such as - 'livingroom' or 'hallway'

###########################################################
###########################################################
# customizable variables

#######################################
# Not camera specific, but allow for
# individual settings.
#######################################
MAKEMOVIE="yes"
REMOVEIMGS="no"
MAKEFAST="no"
#MOVIETYPE=".gif"
MOVIETYPE=".mp4"

USE_CONVERT="no"
FRAMEDELAY_NORMAL_CONVERT=300
FRAMEDELAY_FAST_CONVERT=100
#
USE_FFMPEG="yes"
#FRAMEDELAY_FAST_FFMPEG="setpts=0.125*PTS"


#######################################
# Camera specifics go here...
#######################################
# camera info
camera="<ip-addr:port>"
camuser="<user>"
campwd="pass"
camname="fosX"
camhome=$PRESET_4
camsnap=$camhome
campos=""

# debug mode, does not create jpg or movies but
# it will position the camera if called for
camdebug="no"

#############################
# schedule control
#
#   start and end times, use 24 hour 
snapstart="07:00"
snapstop="17:00"
#   time between snapshot, examples :
#   ":10" = 10 minutes
#   "1:00" = 1 hour
#   "00:00:30" = 30 seconds
snapinterval="00:00:30"

#############################
# Snapshot, image & movie names, image stamping
#
#   snapshot position
snappos=$camsnap
#   stamp the image with something? yes/no 
snapimgstamp="yes"
#   filename stamp? yes/no if no, then use sequence numbering
snapfilestamp="no"
#   cam name on image? yes/no 
snapimgtxt="yes"
#   seq # stamp on image? yes/no
snapseqnum="yes"
#   cam name on image? yes/no
snapcamname="yes"
#   timestamp point size on image
snappoint=16
##############################
# end of customizable variables
###########################################################
###########################################################

