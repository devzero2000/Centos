#!/bin/bash

usage()
{
  echo "Usage: $0 [ -d <ORIGIN DIRECTORY> ] [ -D <DEST DIR> ]"
  exit 2
}

set_variable()
{
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$@\""
  else
    echo "Error: $varname already set"
    usage
  fi
}

##########
# Main script starts here

unset ORIG_DIR 

while getopts 'd:D:?h' c
do
  case $c in
    d) set_variable ORIG_DIR $OPTARG ;;
    D) set_variable DEST_DIR $OPTARG ;;
    h|?) usage ;; esac
done

[ -z "$ORIG_DIR" ] && usage
[ -z "$DEST_DIR" ] && usage

if [ -n "$ORIG_DIR" ]; then
   [ ! -d "${ORIG_DIR}" ] && echo "Error: directory $ORIG_DIR not found" && exit 1
fi

if [ -n "$DEST_DIR" ]; then
   [ ! -d "${DEST_DIR}" ] && echo "Error: directory $DEST_DIR not found" && exit 1
fi

find "$ORIG_DIR" -name "tomcat*.rpm" | \
   while read I; do
	rpmrebuild  -p -d "$DEST_DIR" --change-spec-preamble='sed   -e   "s/.fc36/.el8/"' $I
   done

