# VPTL-PAD-Confo

This script is intended to prepare `.mov` files for BPix Granite video switchers, but **can be easily adapted to suit any need**.

Basicaly, the script scans the `./input/` folder, processes each file and then outputs the converted file to the `./output/` folder.


## Features

* Can be run from either a local or remote folder (UNC)
* Can be used as a watch-folder daemon
* Can guess and chose between ffmpeg x86 or x64, depending on the host system

## ffmpeg

The script uses ffmpeg to do the processing. From there you have two options :

* Choose the right ffmpeg version depending on your system and put `ffmpeg.exe` in the same folder as the script.
* Download both ffmpeg x86 and x64, rename both ffmpeg.exe as `ffmpeg-x86.exe` and `ffmpeg-x64.exe` and put them in the same folder as the script. The script will then guess the right version depending on the host. This solution can be usefull if the script is hosted on a shared folder on the network, and is to be used on both x86 and x64 computers.

## Usage

* Drop files to the `./input/` folder.
* Run the script.
* Retrieve the converted files in the `./output/` folder.
