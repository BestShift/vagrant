# redis.sh

if [ ! -e ~/.setup/redis ]; then
    touch ~/.setup/redis

    apt-install-if-needed redis-server

    # Utilities
    sudo gem install redis-dump 	# Allows to create database dumps - see: https://github.com/delano/redis-dump
fi
