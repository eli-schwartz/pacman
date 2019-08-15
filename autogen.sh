#!/bin/sh -x

if [ -n "$MESON_DIST_ROOT" ]; then
	cd "$MESON_DIST_ROOT" || exit 1
fi

autoreconf -i || exit 1
patch -d build-aux -Np0 -i ltmain-asneeded.patch

exit 0
