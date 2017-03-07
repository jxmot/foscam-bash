#!/usr/bin/env bash

# This script and some of the included script files were
# inspired by - 
#
#     https://gist.github.com/bgerm/5814847
#
# URLs of useful information - 
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
source $2_param.sh
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
# ./fos_movie.sh imagedir cameraname
#
# where:
#       'imagedir' is any accessible path where image files are 
#                  located.
#       'cameraname' is the prefix to the ***_param.sh file
#
###################################################################
#
if [ $# -ne 2 ] ; then
  echo "Usage: `basename $0` IMAGEDIR CAMNAME"
  echo
  exit 2
fi

outdir=${1%/}

# making a movie?
if [ $MAKEMOVIE = "yes" ]; then
    makeMovie
fi
# done!
exit 0
###################################################################
