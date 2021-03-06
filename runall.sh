#!/usr/bin/env bash

# From http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Changing to $DIR"
cd $DIR

if [ -d "servers" ]; then
	echo "servers directory already exists, not checking out sub servers"
else
	mkdir servers

	git clone --recursive https://github.com/jfly/gatekeeper.git servers/gatekeeper
fi

#<<< TODO only run on clark? >>> servers/gatekeeper/startserver.py --port 8042
#<<<PYTHONPATH=. remote/startserver.py --port=8043

## nginx is daemonized, so there's no use running it inside of a screen
sudo killall nginx # For some reason stopping nginx normally doesn't seem to work.
sed "s/REPLACE_WITH_USER/$(hostname)/" nginx.conf > ./tmp-nginx-for-runall.conf
sudo nginx -p "`pwd`" -c ./tmp-nginx-for-runall.conf
