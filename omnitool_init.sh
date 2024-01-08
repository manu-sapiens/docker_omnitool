#!/bin/bash
echo "---------------------"
echo "[->] START v0000.64b"
echo "Top-level container directory:"
ls -l
cd ./omnitool
echo "./omnitool container directory:"
ls -l

echo "[->] UPDATE OMNITOOL if needed"
git pull
output=$(git pull)
if echo "$output" | grep -q "Already up to date."; then
  echo "The repository is already up to date."
else
  echo "New data was fetched."

  echo "[->] YARN INSTALL"
  yarn install

  echo "[->] YARN BUILD"
  yarn build

  #echo "[->] Updating permissions"
  #chmod -R 0777 .
  #chown -Rh node:node .
fi

echo "[->] YARN START "
yarn start -u -rb -R blocks
