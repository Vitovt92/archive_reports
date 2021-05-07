#!/bin/bash
# save checksum
sha256sum ./daily_notes.txt > ./daily_notes_CHECKSUM 

#chesk chesksum
sha256sum -c ./daily_notes_CHECKSUM 
