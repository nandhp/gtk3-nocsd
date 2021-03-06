#!/bin/bash
#
# wrapper.sh - Wrapper to apply gtk3-nocsd to application
#
# Usage: ln -s wrapper.sh ~/bin/evince
#
# Create a symlink to this wrapper script with the name of the program
# you want run without client-side decorations. This wrapper script
# will run the first matching executable in the PATH that is *not* a
# script. This wrapper script is useful if you don't want to add
# gtk3-nocsd to your system-wide LD_PRELOAD or if you only want it
# applied to certain applications.
#

# Location of gtk3-nocsd library
NOCSDLIB="/usr/local/lib/libgtk3-nocsd.so.0"
if [ -z "$NOCSDLIB" ] || ! [ -e "$NOCSDLIB" ]; then
    # Try looking in the same directory as the script
    NOCSDLIB="$(dirname "$(readlink -f "$0")")/libgtk3-nocsd.so.0"
fi
export LD_PRELOAD="$NOCSDLIB:$LD_PRELOAD"
export GTK_CSD=0

# Find the real program (the first one that's not a shell script)
APPNAME="$(basename "$0")"
for APPPATH in $(type -Pa "$APPNAME") /bin/false; do
    head -c2 "$APPPATH" | grep '#!' >/dev/null || break
done

# Run the program with CSD disabled
exec "$APPPATH" "$@"
