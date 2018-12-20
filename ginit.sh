#!/usr/bin/env bash
echo "export PATH=$(pwd)/:\$PATH" >~/.bash_profile
echo "$(pwd)/tools/buildServer.sh" >gradlev
source ~/.bash_profile