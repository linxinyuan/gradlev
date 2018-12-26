#! /usr/bin/expect -f

set timeout -1
set name [lindex $argv 0]
set password [lindex $argv 1]
set port [lindex $argv 2]
set buildPath [lindex $argv 3]
set proPath [lindex $argv 4]

spawn scp -P $port -rv $name:$buildPath/build/outputs/apk $proPath

expect "password:"
send "$password\r"
interact