#!/usr/env sh

sudo rm /var/lib/systemd/credential.secret
sudo systemd-creds setup

exit
