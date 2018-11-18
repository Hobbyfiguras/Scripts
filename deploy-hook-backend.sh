#!/bin/bash

exec < /dev/tty

echo 'post-receive: Triggered.'

export DJANGO_SETTINGS_MODULE=figurabackend.settings_prod

cd /server/live/backend

if [ ! -d env ]; then
  virtualenv env -p python3
fi

source env/bin/activate &&

echo 'post-receive: git check out…'

git --git-dir=/server/git/backend.git --work-tree=/server/live/backend checkout master -f

echo 'post-receive: pip install -r requirements.txt…'

pip install -r figurabackend/requirements.txt &&

echo 'migrate'

sudo su -c "DJANGO_SETTINGS_MODULE=figurabackend.settings_prod env/bin/python figurabackend/manage.py migrate; exit" figuresite &&

echo 'post-receive: copying configs…' &&

sudo cp -rf 'config/uwsgi/figuresite.ini' '/etc/uwsgi-emperor/vassals/figuresite.ini' &&

echo 'Restarting ave imperator'

sudo systemctl restart uwsgi-emperor &&

echo 'post-receive: → done.'
