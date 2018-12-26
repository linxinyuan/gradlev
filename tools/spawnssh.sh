#! /usr/bin/expect -f

set timeout -1
set name [lindex $argv 0]
set password [lindex $argv 1]
set port [lindex $argv 2]
set commandStr [lindex $argv 3]
spawn ssh -o StrictHostKeyChecking=no -p $port $name "eval $commandStr"

expect "password:"
send "$password\r"
expect "SUCCESSFUL"
