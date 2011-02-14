#!/bin/bash
#Author: Kris Occhipinti (A.K.A. Metalx1000)
#Description: Bulk Download Videos from Youtube
#Nov. 2009
#http://www.BASHscripts.info
#GPL v3

curl -s "$1" | \
	grep "watch?"| \
	cut -d\" -f4| \
	while read video
	
do 
	echo $video
	# youtube-dl -b "http://www.youtube.com$video"
	youtube-dl "http://www.youtube.com$video"
done
