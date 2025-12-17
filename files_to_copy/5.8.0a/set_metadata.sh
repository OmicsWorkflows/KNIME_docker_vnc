#!/bin/sh

f="$HOME/Desktop/knime.desktop"

if [ -f "$f" ]; then
    checksum="$(sha256sum "$f" | awk '{print $1}')"
    gio set -t string "$f" metadata::xfce-exe-checksum "$checksum"
fi