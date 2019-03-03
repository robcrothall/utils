#!/bin/bash
cd /home/robc/backup
$mydate .= date '%Y%m%d%H%M%S';
mkdir $mydate;
cd $mydate;
$myfile = "psql$mydate.sql";
echo $myfile
pg_dump -v -U rob > $myfile;
