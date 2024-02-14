#!/bin/bash
echo "[->] START v0001.0003 (git stash version)"

if [ ! -p ./tmp/logpipe ]; then
  echo "Creating pipe"
  mkfifo ./tmp/logpipe
else
  echo "Pipe already exists"
fi

cd ./omnitool
git stash
git pull
echo "[->] YARN START (into a pipe)"
yarn start -u -rb -R blocks --noupdate -ll 2 > ../tmp/logpipe 2>&1 &
