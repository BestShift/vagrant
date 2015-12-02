#!/bin/bash

# Script to set up dependencies for Django on Vagrant.

PGSQL_VERSION=9.4
#CBASE_VERSION=2.5.3

# Need to fix locale so that Postgres creates databases in UTF-8
cp -p /vagrant/etc-bash.bashrc /etc/.bashrc
locale-gen en_US en_US.UTF-8
#dpkg-reconfigure locales

cat <<EOF > /etc/default/locale
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
EOF

# This doesn't work because locales are stupid
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Install essential packages from Apt
apt-get update -y
# Some essential stuff
apt-get install -y build-essential vim git git-core git-flow dos2unix gnupg tree wget ca-certificates
# Python dev packages
apt-get install -y python python-dev python-setuptools python-pip
# Dependencies for image processing with Pillow (drop-in replacement for PIL)
# supporting: jpeg, tiff, png, freetype, littlecms
apt-get install -y libjpeg-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev
# nginx and dependencies
apt-get install -y libvpx1 libgd2-xpm libxpm4 libxslt1.1 nginx-common nginx-full
# additional nginx packages
apt-get install -y libgd-tools fcgiwrap nginx-doc ssl-cert

# virtualenv global setup
if ! command -v pip; then
    easy_install -U pip
fi
if [[ ! -f /usr/local/bin/virtualenv ]]; then
    easy_install virtualenv virtualenvwrapper stevedore virtualenv-clone
fi

# bash environment global setup
cp -p /vagrant/bashrc /home/vagrant/.bashrc

# install our common Python packages in a temporary virtual env so that they'll get cached
if [[ ! -e /home/vagrant/.pip_download_cache ]]; then
    su - vagrant -c "mkdir -p /home/vagrant/.pip_download_cache && \
        virtualenv /home/vagrant/yayforcaching && \
        PIP_DOWNLOAD_CACHE=/home/vagrant/.pip_download_cache /home/vagrant/yayforcaching/bin/pip install -r /vagrant/requirements.txt && \
        rm -rf /home/vagrant/yayforcaching"
fi

# PostgreSQL
if ! command -v psql; then
	sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	apt-get update
	apt-get install -y postgresql-$PGSQL_VERSION libpq-dev postgresql-server-dev-$PGSQL_VERSION
    cp /vagrant/pg_hba.conf /etc/postgresql/$PGSQL_VERSION/main/
    /etc/init.d/postgresql reload
fi

# Couchbase (NEEDS OPTIMIZATION)
if ! command -v cbc; then
	apt-get install -y libev4 libevent-core-2.0-5
	wget --quiet http://packages.couchbase.com/clients/c/libcouchbase-2.5.3_wheezy_amd64.tar 
	tar -xvf libcouchbase-2.5.3_wheezy_amd64.tar 
	mv ./libcouchbase-2.5.3_wheezy_amd64 cb-install 
	cd cb-install
	dpkg -i libcouchbase2-bin_2.5.3-1_amd64.deb libcouchbase2-libev_2.5.3-1_amd64.deb libcouchbase-dbg_2.5.3-1_amd64.deb libcouchbase2-core_2.5.3-1_amd64.deb libcouchbase2-libevent_2.5.3-1_amd64.deb libcouchbase-dev_2.5.3-1_amd64.deb
fi

# Cleanup
apt-get clean

echo "Zeroing free space to improve compression."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY