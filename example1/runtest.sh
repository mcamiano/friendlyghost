#/bin/bash
# [--open] testname testcase.coffee webhost
if [[ "$1" = "--open" ]]
then
  shift
  casperjs $1 $2 \
    --ignore-ssl-errors=yes \
    --testhost="$3" \
    --screenfile=~/Desktop/${1}.png || open ~/Desktop/{$1}.png
else
  casperjs $1 $2 \
    --ignore-ssl-errors=yes \
    --testhost="$3" \
    --screenfile=./${1}.png # || script to upload screenshot.png
fi

