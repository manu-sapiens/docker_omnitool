#!/bin/bash
echo "[->] START v0000.64"
ls -l | cat
echo "[->] UPDATE OMNITOOL if needed"
cd ./omnitool
ls -l | cat
git pull | cat

output=$(git pull)
if echo "$output" | grep -q "Already up to date."; then
  echo "The repository is already up to date."
else
  echo "New data was fetched."

  echo "[->] YARN INSTALL"
  yarn install

  echo "[->] YARN BUILD"
  yarn build


  #echo "[->] YARN INSTALL"
  #yarn install

  #echo "[->] Updating permissions"
  chmod -R 0777 .
  chown -Rh node:node .
fi

echo "[->] YARN START "
yarn start -u -rb -R blocks
