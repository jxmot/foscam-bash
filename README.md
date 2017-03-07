# foscam-bash

This project evolved from trying to fulfill several tasks. I wanted to learn bash, experiment with an IP camera API, and get some additional experience with the Linux command line. At first I didn't plan on combining my efforts. It was *by accident* that stumbled across a *Gist* with a shell script that accessed the same brand & model IP camera that I currently use.

And that original bit of shell script did *almost* everything I needed it to do. So I used it as a starting point and ended up creating what you see in this repository.

Here's a link to the Gist I used - 

<https://gist.github.com/bgerm/5814847>

My modifications and additions included - 

* Functionality
    * Individual cameras can be used by creating a configuration file
    * Pan/Tilt the camera for preset "snapshot" and "home" positions
    * Time stamps are selectable for image file names, and to overlay onto the snapshots.
    * Automatic creation of an output folder
    * Uses `ffmpeg` to create mp4 files
    * Automatic start and stop of snapshots, and movie creation
    * Camera name can be optionally over layed onto the snapshots
* Configuration 
    * Individual Camera info - 
        * IP address
        * login and password
        * camera "home" and "snapshot" position presets
    * Snapshots - 
        * start time
        * end time
        * interval between snapshots
        * time-stamp use
        * auto conversion into a movie (*mp4*)

# Disclaimer

This project is essentially a *work in progress*. It works, but may have some minor bugs. I *intend* on making improvements and adding more commentary. However I do not intend on any additional feature development. Although I plan on porting the functionality to a Node/Javascript project. 

# Usage

* Using a Linux distribution place the `*.sh` files into a folder. 
* Use `chmod` to make them executable. 
* Edit the camera parameter file and provide the necessary IP camera information
* It may be necessary change the first line of all the `*.sh` files from `#!/usr/bin/env bash` to something more appropriate to your environment.

After all editing and such is done, you can run it with - 

```
$ ./fos_main.sh fosX ./snapshots
```

Where `fosX` is the first part of the file named `fosX_params.sh`
And `./snapshots` is the path to where you want the snapshots saved, and optionally wher the MP4 file would be created.

## Platform Details

* Hardware : An old Dell PC that I re-purposed for learning Linux.
* OS : Centos 6 Server
* Camera : Foscom 8910 IP PTZ Camera

# File Structure

All of the `*.sh` files are kept in a single folder. There purposes are as follows - 

* `fos_main.sh` - Top level logic for the application
* `fos_movie.sh` - Top level logic, used for creating movies after the snapshots have been created but the applciation was not configured to automatically create the movie.

The remaining files make up the restS of the application. They must be "sourced" in the following order - 

* `timefunc.sh` - "time" functions - start time, end time, and duration calculations
* `foscamparam.sh` - generic constants and Foscam settings
* `fosX_param.sh` - camera specific constants and settings
* `moviefunc.sh` - functions for making movies (*mp4*) with `ffmpeg`
* `imagefunc.sh` - image time stamp functions
* `foscamfunc.sh` - camera functions such as take snapshot(s) and change position, there are also logging functions
* `utilfunc.sh` - miscellaneous functions including some console output functions for debugging, `ctrl-C` handling, and output folder creation

# Future

Port the functionality to a Node/Javascript project that has better scheduling and file management. I've also had some thoughts about creating a GUI to manage the scheduling and viewing the snapshots and movies.
