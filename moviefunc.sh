#!/usr/bin/env bash

snapdatestart=""
snapdatestop=""


# having trouble with wildcard expansion
function call_convert()
{
    echo "Converting  $1  to  $2  with  $FRAMEDELAY_NORMAL_CONVERT ms delay per frame."
    # necessary when using convert
    echo "MAGICK_THREAD_LIMIT = $MAGICK_THREAD_LIMIT"
#    convert "$1" -delay "$FRAMEDELAY_NORMAL_CONVERT" "$2"
}

# having trouble with wildcard expansion
function call_ffmpeg()
{
    ffmpeg -r 5 -i "$1" "$2"
}

#############################
#   movie file name
function getMovieName()
{
#    local moviespan="_$(echo $snapstart | awk -F: '{ print $1$2 }')-$(echo $snapstop | awk -F: '{ print $1$2 }')"
# should format the date correctly, especially if the 1st
# snap happened sometime "yesterday"... perhaps it should be saved?
#    local moviename="$(date +%Y%m%d)$moviespan"
    local moviename="$camname"-"$snapdatestart"_"$(echo $snapstart | awk -F: '{ print $1$2 }')"-"$snapdatestop"_"$(echo $snapstop | awk -F: '{ print $1$2 }')"
    echo "$moviename"
}

function createMovie()
{
    echo "DEBUG -  $1     $2    " $USE_CONVERT
    echo "DEBUG -  $1     $2    " $USE_FFMPEG

#    if [ $USE_CONVERT = "yes" ]; then
        call_convert "$1" "$2"
#    fi
}

function makeMovie()
{
### createMovie()
    local filePattern="$outdir/*$IMGEXT"
    local imagePattern="n/a"
    local cmdready="no"

    filecount=$(ls -1 $filePattern 2> /dev/null | wc -l)

    moviename="$outdir/$(getMovieName)"
    movie="$moviename$MOVIETYPE"
    
# if using createMovie() again this will need to change
    echo
    echo "Making movie..."
    echo
    echo "PWD = $PWD"
    echo
    echo " filePattern: ${filePattern}"
    echo "   filecount: ${filecount}"        
    echo "       movie: ${movie}"
    echo "        type: ${MOVIETYPE}"
    echo 

    if [ $filecount -gt 0 ]; then
	       
        echo "Creating $movie please wait......."
	
        if [ $camdebug = "no" ]; then
### createMovie()
# {
            if [ $snapfilestamp = "yes" ] ; then
                # not necessary, if checking before call
                if [ $MAKEMOVIE = "yes" ] ; then
                    echo "WARNING : A movie cannot be created using non-sequence numbered files"
                else
                    echo "INFO : A movie will not be created"
                fi
            else
                if [ $MAKEMOVIE = "yes" ] ; then

                    if [ $USE_CONVERT = "yes" ] && [ $USE_FFMPEG = "no" ]; then
                        imagePattern="$outdir/*$IMGEXT"
                        command=(convert -limit memory 8 "$imagePattern" -delay "$FRAMEDELAY_NORMAL_CONVERT" "$movie")
                        cmdready="yes"
                    fi
                    
                    if [ $USE_FFMPEG = "yes" ] && [ $USE_CONVERT = "no" ]; then
                        imagePattern="$outdir/%05d$IMGEXT"
                        command=(ffmpeg -r 5 -i "$imagePattern" "$movie")
                        cmdready="yes"
                    fi

                    if [ $cmdready = "yes" ] ; then
                    
                        echo "Making  $movie  from  $imagePattern, please wait...."
                   
                        "${command[@]}"

                        # check to see if makeing the movie was successful before removing images
                        if [ -f "$movie" ] && [ -s "$movie" ] ; then
                            if [ $REMOVEIMGS == "yes" ]; then
                                echo "Deleting images - $imagePattern"
                                rm -f $imagePattern
                            fi
                            echo "Finished making movie."
                        else
                            echo "Problem with $movie;  JPGs not deleted"
                            echo "Executed - ${command[@]}"
                        fi
                    else
                        echo "ERROR - Instructed to make $movie but no converter was properly selected - "
                        echo "     USE_CONVERT = $USE_CONVERT"
                        echo "     USE_FFMPEG  = $USE_FFMPEG"
                    fi
# } createMovie

# having trouble with wildcard expansion - MIGHT be working now
#                    createMovie "$imagePattern" "$movie"

                fi
            fi
        else
            echo "DEBUG - not making movie"
		fi
    else
        echo "No images found to make movie - $imagePattern"
    fi
    echo
}

