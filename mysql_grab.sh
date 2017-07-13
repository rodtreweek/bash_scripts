#!/bin/bash
# setup the shell environment (set -e and set -o pipefail)
set -e
set -o pipefail

# As root (via sudo) execute ngrep (presumably gnu's ngrep) 
# to grab the output of the mysql SQL statement looking for 
# the tcp info on the interface to the DB
exec sudo ngrep -P ' ' -l -W single -d bond0 -q 'SELECT' 'tcp and dst port 3306' |
  egrep "\[AP\] .\s*SELECT " |
  sed -e 's/^T .*\[AP\?\] .\s*SELECT/SELECT/' -e 's/$/;/' |
  ssh $1 -- 'sudo parallel --recend "\n" -j16 --spreadstdin mysql github_production -f -ss'
