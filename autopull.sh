#!/usr/bin/env bash

set -e

cd dorfbook

git fetch

if ! pgrep dorfbook >/dev/null 2>&1; then
	echo 'Not running'

elif [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
	echo 'Updating from git'

	git pull
	./build.sh

	# TODO: This requires starting in a different port
	#./test.py

else
	echo 'All operational'
	exit
fi

cd ..
mkdir -p run

kill `pidof dorfbook` || true

while pgrep dorfbook >/dev/null 2>&1; do
	sleep 1s
done
sleep 1s

cp -R dorfbook/bin run
cd run/bin
nohup ./dorfbook &

