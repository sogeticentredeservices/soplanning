#!/usr/bin/env sh

docker build -t sogeti/soplanning:1.42 -t sogeti/soplanning:1.42-stretch . "$@"
