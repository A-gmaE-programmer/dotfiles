import os
import subprocess
from io import BytesIO
from random import randrange
from time import sleep

# Script for selecting wallpaper (SUPER W)

HOME = os.environ['HOME']
SCRIPTSDIR = HOME+"/.config/hypr/scripts"

# Wallpapers path
wallDIR = HOME+"/Pictures/wallpapers"

# Max length of nested filepath for images
# Image names will never be truncated
max_subpath_len = 40

# Graph of bez curve:
# Transition config
SWWW_PARAMS = "--transition-fps {FPS} --transition-type {TYPE} --transition-duration {DURATION} --transition-bezier {BEZIER}".format(
        FPS = 30,
        TYPE = "wipe",
        DURATION = 1,
        BEZIER="0,.85,.6,.4",
        )

def killIfActive(pname: str):
    os.system("if pidof {proc} > /dev/null; then pkill {proc}; fi".format(proc=pname))

# Check if swaybg is running and kill it
killIfActive("swaybg")

path_fetch_cmd = f"find {wallDIR} | grep -E \".jpg$|.jpeg$|.png$|.gif$\""

# Retrieve image files
pic_paths = subprocess.run(
        path_fetch_cmd,
        capture_output=True,
        shell=True
    )\
    .stdout\
    .decode('ascii')\
    .strip()\
    .split()

# TODO: time to organise the picture so that more nested directories are shown later

rofi_command="rofi -show -i -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

# Generate menu names for rofi
default_segments = wallDIR.count("/") + 1
rofi_entries = BytesIO()
i: int = 1

for path in pic_paths:
    rofi_entries.write(str(i).encode())
    rofi_entries.write(b'. ')
    i += 1
    path_segments = path[1:].split("/")
    name = ""
    if len(path_segments) > default_segments:
        max_segment_len = max_subpath_len // (len(path_segments) - default_segments)
        for segment in path_segments[default_segments-1:-1]:
            if len(segment) > max_segment_len:
                name += segment[:max_segment_len] + "~/"
            else:
                name += segment + "/"
            pass
    img_name, sep, filetype = path_segments[-1].partition(".")
    name += img_name

    rofi_entries.write(name.encode())
    rofi_entries.write(b'\x00icon\x1f')
    rofi_entries.write(path.encode())
    rofi_entries.write(b'\n')

# Random
rofi_entries.write(str(i).encode())
rofi_entries.write(b'. Random')

def main():
    choice = subprocess.run(rofi_command, input=rofi_entries.getvalue(), capture_output=True, shell=True).stdout.decode('ascii').strip()
    if not choice:
        exit(0)
    
    # print(choice)
    
    # Now we tell swww to do magic
    index = int(choice.partition('.')[0])
    
    # Random choice
    if index == i:
        index = randrange(i)
    
    try:
        img_path = pic_paths[index-1]
    except IndexError:
        print("Image not found")
        exit(1)

    os.system("swww img {img_path} {SWWW_PARAMS}".format(img_path=img_path, SWWW_PARAMS=SWWW_PARAMS))

# Kill rofi if running
killIfActive("rofi")
main()
os.system(
"""\
sleep 0.5
{SCRIPTSDIR}/PywalSwww.sh
sleep 0.2
{SCRIPTSDIR}/Refresh.sh
""".format(SCRIPTSDIR=SCRIPTSDIR))
