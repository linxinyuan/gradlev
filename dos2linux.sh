#!/usr/bin/env bash
rw=`dirname $0`
SCRIPTPATH_HOME=$(cd $rw && pwd)
SCRIPTPATH=$(cd $rw && pwd)/tools

dos2unix $SCRIPTPATH_HOME/ginit.sh
dos2unix $SCRIPTPATH_HOME/greset.sh

dos2unix $SCRIPTPATH/buildServer.sh
dos2unix $SCRIPTPATH/scp.sh
dos2unix $SCRIPTPATH/loginssh.sh
dos2unix $SCRIPTPATH/spawnssh.sh
