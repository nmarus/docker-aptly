#!/bin/bash

init_aptly() {

    #create gpg base config
    su -c "gpg --list-keys"  aptly &> /dev/null

    #check if debian or ubuntu container...
    if [ -f /usr/share/keyrings/debian-archive-keyring.gpg ]; then
        #import local debian distro keys
        su -c "gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import" aptly
    elif [-f /usr/share/keyrings/ubuntu-archive-keyring.gpg ]; then
        #import local ubuntu distro keys
        su -c "gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import" aptly
    else
        echo "Local container is not debian/ubuntu based or release keys not found where expected..."
        exit 1
    fi

    #create nginx root folder in /aptly
    su -c "mkdir -p /aptly/.aptly/public" aptly
}

#reset owner on aptly folder
chown -R aptly:aptly /aptly

#check for first run
if [ ! -e /aptly/.aptly/public ]; then
    init_aptly
fi

#run nginx in non daemon mode
nginx -g "daemon off;"
