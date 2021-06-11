#!/bin/sh

verfile=$1
editfile=$2
outfile=$3

read -r version < "$verfile"

version=${version#v}; fullversion=${version}
major=${version%%.*}; version=${version#${major}.}
minor=${version%%.*}; version=${version#${minor}.}
patch=${version%%-*}; version=${version#${patch}}; version=${version#-}

revcount=${version%%-*}; version=${version#${revcount}-}
gitrev=${version%%-*}; version=${version#${hash}}

dirty=
if [ "$version" = '-dirty' ]; then
	dirty=dirty
fi

fromgit=0
if [ -n "$revcount" ]; then
	fromgit=1
fi

sed \
	-e "s/[@]PM_FULLVER[@]/\"$fullversion\"/" \
	-e "s/[@]PACKAGE_VERSION[@]/$fullversion/" \
	-e "s/[@]PM_MAJOR[@]/$major/" \
	-e "s/[@]PM_MINOR[@]/$minor/" \
	-e "s/[@]PM_PATCH[@]/$patch/" \
	-e "s/[@]PM_REVCOUNT[@]/$revcount/" \
	-e "s/[@]PM_GITREV[@]/\"$gitrev\"/" \
	-e "s/[@]PM_DIRTY[@]/\"$dirty\"/" \
	-e "s/[@]PM_FROMGIT[@]/$fromgit/" \
	"$editfile" > "$outfile"
