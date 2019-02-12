#!/usr/bin/env sh

docker build -t sogeti/soplanning:latest -t sogeti/soplanning:1.43 -t sogeti/soplanning:1.43-stretch . "$@"
