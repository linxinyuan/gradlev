#!/usr/bin/env bash
rw=`dirname $0`
SCRIPTPATH=$(cd $rw && pwd )/tools

while getopts "c" opt; do
  case $opt in
    c)
      $SCRIPTPATH/buildServer.sh -c
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

$SCRIPTPATH/buildServer.sh