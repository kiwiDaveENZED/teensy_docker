#!/bin/bash

cd /teensyduino 
cp -ru /src/* /teensyduino/src 
cp -ru /libs/* /teensyduino/libraries 
/usr/bin/python3.8 -m lib_json_generator /teensyduino/libraries
/usr/bin/python3.8 -m libs_cmake /teensyduino/libraries
export CC=/teensyduino/bin
export CXX=/teensyduino/bin
export LIBRARY_PATH=/teensyduino/include:$LIBRARY_PATH
if [ ${TEENSY_VERSION} -eq 35 ] || [ ${TEENSY_VERSION} -eq 36 ]
then
     find /teensyduino/include/fpu/ -maxdepth 1 -type f -exec cp {} /teensyduino/include \;
fi
cmake -DCMAKE_TOOLCHAIN_FILE=/teensyduino/teensy_toolchain.cmake \
     -DCMAKE_AR=/usr/bin/ar -DTEENSY_VERSION:INTERNAL=${TEENSY_VERSION} \
     -B /teensyduino/build -S . 

chmod -R 777 /teensyduino/build
cd /teensyduino/build
make -j$(nproc)
teensy_loader_cli --mcu=TEENSY${TEENSY_VERSION} -w -v main.hex