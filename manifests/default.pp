# ===
# Installation and configurations
# ===

# Enable XDebug ("0" | "1")
$use_xdebug = "0"

# Install system updates on every boot
exec { 'Update System':
    command             => 'apt-get update',
}
Exec['apt-get update'] -> Package<| |>


# The following packages will be installed
include stdlib
include epel
#include concat
include couchbase
include python


# Configuring the installations
class { 'couchbaseDefault':
    size     => 1024,
    user     => 'couchbase',
    password => 'password',
    version  => latest,
}

couchbase::bucket { 'memcached':
    port     => 11211,
    size     => 1024,
    user     => 'couchbase',
    password => 'password',
    type     => 'memcached',
    replica  => 1
}

couchbase::client { 'python': }

