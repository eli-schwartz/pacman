#!/bin/sh

version=
root=$1
verfile=$2
if [ -f "$verfile" ]; then
	read version < "$verfile"
fi

if newversion=$(GIT_CEILING_DIRECTORIES="$root/../" git -C "$root" describe --abbrev=4 --dirty); then
	if [ "$verfile" = - ]; then
		printf '%s\n' "$newversion"
	elif [ "$version" != "$newversion" ]; then
		printf '%s\n' "$newversion" > "$verfile"
	fi
else
	exit 1
fi
