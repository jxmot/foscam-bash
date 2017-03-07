#!/usr/bin/env bash

# This script and some of the included script files were
# inspired by - 
#
#     https://gist.github.com/bgerm/5814847
#
# URLs to useful information - 
#
# http://linuxcommand.org/wss0160.php
# http://tldp.org/LDP/abs/html/
# http://linuxcommand.org/writing_shell_scripts.php
#
###################################################################
#
# NOTE: the files below must appear in this order - 
#
# time/scheduling functions
source timefunc.sh
# global variables and 'constants'
source foscamparam.sh
# use camera specific info, provided as an arg to this script
source $1_param.sh
# movie / conversion functions
source moviefunc.sh
# image capture, create, edit functions
source imagefunc.sh
# camera functions
source foscamfunc.sh
# everything else
source utilfunc.sh
###################################################################
# usage:
#
# ./fos_main.sh cameraname outputdir 
#
# where:
#       'cameraname' is the prefix to the ***_param.sh file
#       'outputdir' is any accessible path
#
###################################################################
#
if [ $# -ne 2 ] ; then
  echo "Usage: `basename $0` CAMERANAME OUTDIR"
  echo
  exit 2
fi

# global, used in - 
# moviefunc.sh
# foscamfunc.sh
outdir=${2%/}

showBanner

# if using both paths, create each
createOutDir $outdir

setCtrap

showCaptureInfo

# don't return until it's time...
tellMeWhenTime $snapstart
# position the camera
gotoPreset $snappos
# to start taking snapshots...
takeSnapShots $snapdur $snapwait
# when that's done send the camera home...
homeCamera
# making a movie?
if [ $MAKEMOVIE = "yes" ]; then
    makeMovie
fi
# done!
logEntryEnd

###################################################################
