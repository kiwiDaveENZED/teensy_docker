#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
./build.sh
docker run -t -i --privileged \
     -v /dev/bus/usb:/dev/bus/usb \
     -v ${DIR}/src:/src \
      teensy_dev:latest