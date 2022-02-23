#!/bin/bash

echo -n $VNCPASSWORD | vncpasswd -f > ~/.vnc/passwd
chmod go-rwx ~/.vnc/passwd

export VNCPASSWORD=""

if [ ! -v "$CONTAINER_TIMEZONE" ]; then
 echo ${CONTAINER_TIMEZONE} >/etc/timezone
# problem with permissions for this symlink if running container under knimeuser
# ln -sf /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime
 echo "container timezone set to ${CONTAINER_TIMEZONE}"
 env TZ ${CONTAINER_TIMEZONE}
fi

# remove display lock - if locked, vnc cannot initiate
# happens eg. if updating container to new image (the lock from first vnc will be saved)
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/*
vncserver :1 -geometry 1680x1050 -depth 24 && tail -F $HOME/.vnc/*.log