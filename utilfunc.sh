#!/usr/bin/env bash

#############################
# calculate duration and interval
snapwait=$(echo $snapinterval | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
snapdur=$(getDurationTime $snapstart $snapstop)

function showBanner()
{
    echo
    echo
    if [ "$camdebug" = "yes" ]; then
        echo "=================== DEBUG ===================="
    else
        echo "=============================================="
    fi
    echo "$(date +"%Y/%m/%d %H:%M:%S")"
    echo
}

function showFooter()
{
    echo
    echo
    if [ "$camdebug" = "yes" ]; then
        echo "=================== DEBUG ===================="
    else
        echo "=============================================="
    fi
    echo
}


function createOutDir()
{
local _outdir=$1

    if [ -d "$_outdir" ]; then
        echo "Using the $_outdir folder for output"
    else
        echo "Creating the $_outdir folder for output"
        if [ "$camdebug" = "no" ]; then
            mkdir -p $_outdir
        else
            echo "DEBUG - mkdir -p $_outdir"
        fi
    fi
}


function setCtrap()
{
    if [ $MAKEMOVIE = "no" ]; then
        echo "Press Ctrl-C stop capture"
    else
        echo "Press Ctrl-C to start stitching the movie."
        echo "OR a movie will be made after " $snapstop "."
    fi

    trap ctrl_c INT
}


function showDebugInfo()
{
    if [ "$camdebug" = "yes" ]; then
        echo
        echo "Snapshot Settings -"
        echo "  snapstart    = "$snapstart
        echo "  snapstop     = "$snapstop
        echo "  snapwait     = "$snapwait
        echo "  snapinterval = "$snapinterval
        echo "  snapdur      = "$snapdur
        echo "  snappos      = "$snappos
        echo "  snapimgstamp = "$snapimgstamp
        echo "  snapimgtxt   = "$snapimgtxt
        echo
    fi
}


function showCaptureInfo()
{
    echo
    echo "Capturing images from $camname at $camera" 
    echo
    echo "Snapshots will start at " $snapstart
    echo "And will stop at " $snapstop
    howlong=$(getDurationTime $snapstart $snapstop)
    echo "Pictures will be taken for " $howlong " - " $(showtime $howlong)
    picqty=$((howlong / snapwait))
    echo "There will be " $picqty " snapshots taken"
    echo
    when=$(getWhenTime $snapstart)
    echo "In " $when " seconds from now, or"
    echo "In " $(showtime $when) " hh:mm:ss from now"
    echo "There will be " $snapwait " seconds"
    echo "between snapshots for" $snapdur "seconds"
    showDebugInfo
    showFooter
    echo
}


