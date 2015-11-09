#!/usr/bin/env bash

cat > "/etc/init/mongos.conf" << '_EOF_'
limit fsize unlimited unlimited  # (file size)
limit cpu unlimited unlimited    # (cpu time)
limit as unlimited unlimited     # (virtual memory size)
limit nofile 64000 64000         # (open files)
limit nproc 64000 64000          # (processes/threads)

pre-start script
    mkdir -p /var/log/mongodb/
end script

start on runlevel [2345]
stop on runlevel [06]

script
    ENABLE_MONGOS="yes"
    if [ -f /etc/default/mongos ]
    then
        . /etc/default/mongos
    fi
    if [ "x$ENABLE_MONGOS" = "xyes" ]
    then
        exec start-stop-daemon --start --quiet --chuid mongodb \
            --exec  /usr/bin/mongos -- --config /etc/mongod.conf
    fi
end script
_EOF_
