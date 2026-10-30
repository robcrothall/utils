#!/bin/bash
set -vx
MAX=9
EMAIL=rob@localhost
PART=sda1
USE=`df -h |grep $PART | awk '{ print $5 }' | cut -d'%' -f1`
if [ $USE -gt $MAX ]; then
echo "Percent used: $USE" | mutt -s "Running out of disk space" $EMAIL
fi
