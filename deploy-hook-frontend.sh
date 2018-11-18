#!/bin/bash

echo 'post-receive: Triggered.'

cd /server/live/frontend

echo 'post-receive: git check out…'

git --git-dir=/server/git/frontend.git --work-tree=/server/live/frontend checkout master -f

echo 'post-receive: npm install…'

npm install &&

echo 'post-receive: building…' &&

npm run build &&

echo 'copying build' &&

cd /server/live

rm -rf html/*

cp -r frontend/dist/* html/

echo 'post-receive: → done.'

