#!/bin/bash

# save checksum

NOW_TIME=$(date +%s)
MODIF_TIME=$(stat --format=%Y daily_notes.txt)
DIF_TIME=24
DIF_TIME_SEC=$(expr $DIF_TIME \* 60 \* 60 )
echo $MODIF_TIME

if ! $(sha256sum --status -c ./daily_notes_CHECKSUM)
then 
	echo "CHECKSUM doesn't match"
	if [ $(expr $NOW_TIME - $MODIF_TIME) -gt $DIF_TIME ]
	then
		echo "time more than $DIF_TIME hours"
		echo "------------------------" >> ./archive_notes.txt 
		cat ./daily_notes.txt >> ./archive_notes.txt
		sha256sum ./daily_notes.txt > ./daily_notes_CHECKSUM 
	fi  
fi
#chesk chesksum
echo $(sha256sum --status -c ./daily_notes_CHECKSUM) 
