# postgresql.sh

function createdb-if-needed {
    for dbname in $@; do
        $(psql -l | grep -q "$dbname") || createdb "$dbname"
    done
}

function dropdb-if-needed {
    for dbname in $@; do
        $(psql -l | grep -q "$dbname") && dropdb "$dbname"
    done
}

if [ ! -e ~/.setup/postgresql ]; then
    apt-install-if-needed postgresql-9.3 postgresql-contrib-9.3 \
        postgresql-doc-9.3 postgresql-server-dev-9.3

    sudo -u postgres createuser --superuser $USER &> /dev/null
    sudo -u postgres createdb bestshift &> /dev/null

    touch ~/.setup/postgresql
fi

