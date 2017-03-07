#!/usr/bin/env bash

# constants
MIDNIGHT=$((24*60*60))
#echo "MIDNIGHT  = $MIDNIGHT"
#echo

# utility
function getTimeNowSec()
{
    local timenow=$(date +%T | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    echo "$timenow"
}

function getDuration()
{
    local first=$1
    local last=$2
    local dur=0

    if [ $((last)) -ge $((first)) ]; then
        dur=$(($last-$first))
    else
        if [ $((getTimeNowSec)) -lt $((MIDNIGHT)) ]; then
            dur=$(($last+$MIDNIGHT-$first))
        fi
    fi
    echo "$dur"
}

function getDurationTime()
{
    local first=$(echo "$1" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    local last=$(echo "$2" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')

    local ret=$(getDuration $first $last)
    echo "$ret"
}

# mySleep $SIX_HRS "A"
# NOTE : the echo in this function will have the
# echo return of it's caller concatenated after
# it... weird.
function mySleep()
{
    echo "$2 @ $1"
    sleep $1
}

# Basic time control...

# function isNow()
# 
# if [ "$(isNow $sometime)" = "false" ]; then
#   echo "NOT YET"
# else
#   echo "the time is NOW, or LATER"
# fi
#
# where : $sometime is the target time in seconds
# past midnight
#
# examples :
#   $1 = 17:00
#  now = 16:45
#  ret = false
#
#   $1 = 17:00
#  now = 17:01
#  ret = true
#
function isNow()
{
    local ret="false"
        
    if [ $(($1)) -le $((getTimeNowSec)) ]; then
        ret="true"
    fi

    echo "$ret"
}

function getWhen()
{
    local nowtime=$(getTimeNowSec)
    local when=0
    local target=$1
    
    if [ $(($target)) -gt $(($nowtime)) ]; then
        when=$(($target-$(($nowtime))))
    else
        if [ $(($target)) -lt $(($nowtime)) ]; then
            when=$(($target+$MIDNIGHT-$nowtime))
        fi
    fi

    echo "$when"
}

# used in utilfunc.sh
function getWhenTime()
{
    local ret=0
    local target=$(echo $1 | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    ret=$(getWhen $target)
    echo "$ret"
}

function tellMeWhen()
{
    local FIVE_SEC=5
    local THIRTY_SEC=$((FIVE_SEC*6))
    local ONE_MIN=$((60))
    local FIVE_MIN=$((ONE_MIN*5))
    local TEN_MIN=$((FIVE_MIN*2))
    local TWEN_MIN=$((TEN_MIN*2))
    
    local ONE_HOUR=$((ONE_MIN*60))
    local TWO_HRS=$((ONE_HOUR*2))
    local FOUR_HRS=$((ONE_HOUR*4))
    local SIX_HRS=$((ONE_HOUR*6))
    local EIGHT_HRS=$((ONE_HOUR*8))

    local target=$1
    local ret="false"
    
    if [ "$(isNow "$target")" = "false" ]; then
    
        while [ "$ret" = "false" ]; do
        
            local when=$(getWhen $target)
            
            if [ $((when)) -gt $((EIGHT_HRS)) ]; then
                mySleep $SIX_HRS "A"
            else
                if [ $((when)) -gt $((FOUR_HRS)) ]; then
                    mySleep $TWO_HRS "B"
                else
                    if [ $((when)) -gt $((ONE_HOUR)) ]; then
                        mySleep $ONE_HOUR "C"
                    else
                        if [ $((when)) -gt $((TWEN_MIN)) ]; then
                            mySleep $TEN_MIN "D"
                        else
                            if [ $((when)) -gt $((FIVE_MIN)) ]; then
                                mySleep $ONE_MIN "E"
                            else
                                if [ $((when)) -gt $((ONE_MIN)) ]; then
                                    mySleep $THIRTY_SEC "F"
                                else
                                    if [ $((when)) -gt 0 ]; then
                                        mySleep $when "G"
                                    fi
                                    ret="true"
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        done
    else
        ret="true"
    fi
    
    echo "$ret"
}

# used in fos_main.sh
function tellMeWhenTime()
{
    local ret=""
    local when=$(echo $1 | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    ret=$(tellMeWhen $when)
    echo "$ret"
}

# used in utilfunc.sh
function showtime() 
{
    local num=$1
    local min=0
    local hour=0
    local day=0
    
    local ret="?"
    
    if((num>59));then
        ((sec=num%60))
        ((num=num/60))
        if((num>59));then
            ((min=num%60))
            ((num=num/60))
            if((num>23));then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    ret=$(printf "%02d:%02d:%02d" $hour $min $sec)
    echo "$ret"
}
