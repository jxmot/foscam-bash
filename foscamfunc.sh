#!/usr/bin/env bash

#
# common global vars
response="n/a"

###################################################################
# functions

###############################################################################
###############################################################################
###############################################################################
firstfile=''
lastfile=''
# To Do : move log funcs to 'logfuncs.sh'
function logEndOutput()
{
    local logout=$(
        echo "\n"
        echo "============================================\n"
        echo "Images from  - $camera\n"
        echo "Ending on    - $(date +"%Y/%m/%d %H:%M:%S")\n"
        echo "Started with - $firstfile\n"
        echo "Ended with   - $lastfile\n"
        echo "Movie        - $MAKEMOVIE\n"
        if [ $MAKEMOVIE = "yes" ]; then
            echo "Movie Name   - $(getMovieName)\n"
        fi
        echo "\n"
    )
    echo "$logout"
}

function logEntryEnd()
{
    if [ "$camdebug" = "yes" ]; then
        echo
        echo "logging to   - $outdir/$IMGLOGFILE"
        echo -e $(logEndOutput)
    else
        logEndOutput >> $outdir/$IMGLOGFILE
    fi
}

function logCamResponse()
{
    if [ "$camdebug" = "yes" ]; then
        echo
        echo "On $(date +"%Y/%m/%d %H:%M:%S") received response - $1 - to $outdir/$RESPLOGFILE"
        echo
    else
        echo "On $(date +"%Y/%m/%d %H:%M:%S") received response - $1" >> $outdir/$RESPLOGFILE
    fi
}

function logCamAction()
{
    if [ "$camdebug" = "yes" ]; then
        echo
        echo "On $(date +"%Y/%m/%d %H:%M:%S") performed action - $1 - to $outdir/$RESPLOGFILE"
        echo
    else
        echo "On $(date +"%Y/%m/%d %H:%M:%S") performed action - $1" >> $outdir/$RESPLOGFILE
    fi
}
###############################################################################
###############################################################################
###############################################################################
# To Do : ? move command strings to foscamparam ?
# To Do : depending, convert discrete cam actions to funcs. move callers to
# 'ipcamfuncs.sh'
#
function gotoPreset()
{
	echo

    if [ "$camdebug" = "yes" ]; then
        echo "DEBUG - moving to preset : $1"
        echo
    fi
    
    if [ "$campos" != $1 ]; then

        echo
        echo "Please wait for the camera to finish moving..."
###
        command="http://$camera/decoder_control.cgi?command=$1&user=$camuser&pwd=$campwd"
        logCamAction $command

        response=$(curl --silent --write-out %{http_code} --connect-timeout 5 $command)
        logCamResponse $response
###
        
        campos=$1
        if [ "$camdebug" = "yes" ]; then
            sleep $DEBUG_PRESET_DELAY
        else
            sleep $PRESET_DELAY
        fi
    else
        echo 
        echo "Camera is already in position"
    fi
    
	echo
	echo
}

#######################################
# takeSnapShot filepathname.ext
#
function takeSnapShot()
{
###
    command="http://$camera/snapshot.cgi?user=$camuser&pwd=$campwd"
###
    logCamAction $command
    
    _file=$1
    _timest=$2
    _textst=$3
    _fname=$4
	
#    echo "SNAP!  $camname  :  $_file  :  $_timest  :  $_textst  :  $_fname"

    if [ "$camdebug" = "no" ]; then
###
        response=$(curl --silent --write-out %{http_code} --connect-timeout 5 $command -o $_file)

        if [ "$response" = "200" ]; then
            if [ $snapimgstamp == "yes" ]; then
                stampImage "$_file" "$_timest" "$_textst" "$_fname"
            fi
            lastfile=$_file
        else
            rm -f $_file
            # convert to logError()
            echo "Could not grab image $_file  $response" >> $outdir/error.log

            # this will copy the last good image to any failed 
            # captures that followed it
            if [ -n "$lastfile" ]; then
                cp $lastfile $_file
                # restamp image w/ 'copy'
            fi
        fi
###        
    else
        response="DEBUG - 200"
        echo "DEBUG - $command"
    fi
    logCamResponse $response
}

#######################################
# takeSnapShots duration interval
#
function takeSnapShots()
{
local fname
local seqnumb=1

    # added to image if fosX_param.sh:$snapimgstamp = "yes"
    timestamp=$(date +"%Y/%m/%d %H:%M:%S")

    if [ $snapfilestamp = "yes" ] ; then
        # this works for timestamp file names
        fname=$(date +"%Y%m%d_%H%M%S")
    else
        fname=$(printf %05d $seqnumb)
        seqnumb=$(($seqnumb+1))
    fi

    file=$outdir/$fname$IMGEXT
    
    # use this to track the files we created during this session
    firstfile=$file
    
    start=$(date +%s)
    snapdatestart="$(date +%Y%m%d)"
    echo "Start date - $snapdatestart"
    end=$(date +%s)

    while [ $(( $end - $start )) -lt $(($1)) ]; do

#        echo "TAKE!  $camname  :  $file  :  $timestamp  :  $camname  :  $fname"

        takeSnapShot "$file" "$timestamp" "$camname" "$fname"
	
        end=$(date +%s)
        snapdatestop="$(date +%Y%m%d)"
    
        sleep $2
    
        # create the next file name
        if [ $snapfilestamp = "yes" ] ; then
            fname=$(date +"%Y%m%d_%H%M%S")
        else
            fname=$(printf %05d $seqnumb)
            seqnumb=$(($seqnumb+1))
        fi
        file=$outdir/$fname$IMGEXT
        
        timestamp=$(date +"%Y/%m/%d %H:%M:%S")
    done
}
#######################################
# 
function homeCamera()
{
	gotoPreset $camhome
}

#######################################
# 
doexit=0

function ctrl_c() 
{
    if [ $doexit -eq 1 ]; then
        exit 1
    fi
	
    doexit=1
    
    echo
    echo "Detected ctrl-c... please wait..."
 
    logCamResponse $response

    logEntryEnd
	
    homeCamera
	
    if [ $MAKEMOVIE = "yes" ]; then
        makeMovie
    fi
    
    echo "Done, exiting now."
    echo

    exit 1
}
