#!/bin/bash
scanimage --resolution=300 --source=Flatbed --format=jpeg --mode=Gray > $1.jpg
eog $1.jpg
#montage -verbose -label '%f' -font Helvetica -pointsize 10 -background '#ffffff' -fill 'grey' -define jpeg:size=200x200 -geometry 200x200+2+2 -auto-orient *.jpg contactlight.jpg

