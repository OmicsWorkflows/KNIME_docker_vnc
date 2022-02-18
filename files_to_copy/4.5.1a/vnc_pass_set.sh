#!/bin/bash

while true; do
  ENTRY=`zenity --password --title="VNC password"`
  len=`expr length "$ENTRY"`
  case $? in
     0)
	if ((len < 6))
	then
	  zenity --error --width=400 --text="Password have to be at least 6 characters long!\\n\\nPlease try again." --title="Warning!"
	  continue
	fi
	printf "`echo $ENTRY`\n`echo $ENTRY`\n\n" | vncpasswd
	zenity --info --text="VNC password changed!" --width=200
	break
	;;
     1)
        zenity --info --text="Password entry canceled, exitting." --title="Canceled"  --width=200
        exit 1
        ;;
    -1)
        zenity --error --text="An unexpected error has occurred." --title="Error!"  --width=200
        exit 1
  esac
done