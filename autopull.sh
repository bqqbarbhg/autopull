#!/usr/bin/env bash

set -e

cd repo

git fetch

if ! pgrep dorfbook >/dev/null 2>&1; then
	echo 'Not running'

elif [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
	echo 'Updating from git'

	git pull
	./build.sh
	./test.py

else
	echo 'All operational'
	exit
fi

cd ..
mkdir -p run

kill `pidof dorfbook` || true
cp -R repo/bin run

nohup run/dorfbook &

