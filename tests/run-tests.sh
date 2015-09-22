#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t internetarchive/rethinkdb $script_dir || exit 1

for python in python2.7 python3.4
do
	docker run --rm -i -t --volume="$script_dir/..:/rethinkstuff" internetarchive/rethinkdb /sbin/my_init -- \
		bash -c "cd /rethinkstuff && virtualenv -p $python /tmp/venv \
			&& source /tmp/venv/bin/activate \
			&& pip install pytest . \
			&& py.test -v -s tests"
done
