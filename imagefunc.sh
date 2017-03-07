#!/usr/bin/env bash

# stamp the image with time and text (optional)
# stampImage $file $timestamp $camname $seqnumb
function stampImage()
{
_firstamp=$1
_tmstamp=$2
_txstamp=$3
_snstamp=$4
allstamp=''

###################
# PUT ALL 'snap' option checks here!
###################


    if [ "$snapimgtxt" = "no" ]; then
        allstamp="$_tmstamp"
    else
        allstamp="$_txstamp  $_tmstamp"
    fi
    
    convert $_firstamp -pointsize $snappoint \
                -draw "gravity southeast \
                    fill black  text 0,12 '${allstamp}' \
                    fill white  text 1,11 '${allstamp}' " \
                $_firstamp

    if [ "$snapseqnum" = "yes" ] ; then
        convert $_firstamp -pointsize $snappoint \
                    -draw "gravity northwest \
                        fill black  text 10,12 '${_snstamp}' \
                        fill white  text 11,11 '${_snstamp}' " \
                $_firstamp
    fi
}

function restampImage()
{
_stampfile=$1
_restamp=$2

    echo "$_stampfile  with  $_restamp"
    echo

    convert $_stampfile -pointsize $snappoint \
                -draw "gravity northwest \
                    fill black  text 10,12 '${_restamp}' \
                    fill white  text 11,11 '${_restamp}' " \
            $_stampfile
}
