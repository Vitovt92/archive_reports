#!/bin/bash

# configure target files
if [ -e arch.conf ]
then
  # file where to write daily notes
  DAILY_NOTES_FILE=` grep DAILY_NOTES_FILE arch.conf | cut -d '=' -f2 `
  # file where to store all daily notes
  ARCHIVE_NOTES_FILE=` grep ARCHIVE_NOTES_FILE arch.conf | cut -d '=' -f2 `
else
  DAILY_NOTES_FILE=daily_notes.txt
  ARCHIVE_NOTES_FILE=archive_notes.txt
fi

# file with last checksum of DAILY_NOTES_FILE
DAILY_NOTES_CHECKSUM_FILE=./daily_notes_CHECKSUM 
# How many hours wait after last modification until rewrite checkcum and put notes to archive 
DIF_TIME=22
# time now. In seconds since 1970
NOW_TIME=$(date +%s)
# time when notes file have being modified last time
MODIF_TIME=$(stat --format=%Y $DAILY_NOTES_FILE)
#convert DIF_TIME to seconds
DIF_TIME_SEC=$(expr $DIF_TIME \* 60 \* 60 )

 echo $(sha256sum -c $DAILY_NOTES_CHECKSUM_FILE) 
 echo " $(date -d@$( expr $DIF_TIME_SEC - $(expr $NOW_TIME - $MODIF_TIME)) -u +%H:%M:%S) left for   "

if  [ $(expr $NOW_TIME - $MODIF_TIME) -gt $DIF_TIME ] &&  ! $(sha256sum --status -c $DAILY_NOTES_CHECKSUM_FILE) 
#if   ! $(sha256sum --status -c $DAILY_NOTES_CHECKSUM_FILE) 
then 
	echo "CHECKSUM doesn't match"
#if [ $(expr $NOW_TIME - $MODIF_TIME) -gt $DIF_TIME ]
	#then
		echo "time more than $DIF_TIME hours"
		echo "------------ $(date) ------------" >> $ARCHIVE_NOTES_FILE 
		cat $DAILY_NOTES_FILE >> $ARCHIVE_NOTES_FILE
		sha256sum $DAILY_NOTES_FILE > $DAILY_NOTES_CHECKSUM_FILE 
#	fi  
fi
