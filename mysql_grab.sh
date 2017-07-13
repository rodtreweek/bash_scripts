#!/bin/bash
set -e
set -o pipefail
exec sudo ngrep -P ' ' -l -W single -d bond0 -q 'SELECT' 'tcp and dst port 3306' |
  egrep "\[AP\] .\s*SELECT " |
  sed -e 's/^T .*\[AP\?\] .\s*SELECT/SELECT/' -e 's/$/;/' |
  ssh $1 -- 'sudo parallel --recend "\n" -j16 --spreadstdin mysql github_production -f -ss'
