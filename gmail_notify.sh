#!/usr/bin/env bash

###  EDIT FOLLOWING TWO VARIABLES ###

# The email address you use to login to Gmail or Google Apps.
user=XXXXX@gmail.com

# The password you use to login to Gmail or Google Apps.
pass=XXXXX

###  DON'T EDIT BELOW THIS LINE ###

m=$(curl -s -u $user:$pass https://mail.google.com/mail/feed/atom | \
  perl -ne 'print $1 if /<fullcount>(.*)<\/fullcount>/ && $1 > 0')

if [ -n "$m" ]
then
  notify-send -i mail-unread "You have $m mail"
fi
