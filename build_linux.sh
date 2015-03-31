#!/bin/sh

rm -rf dist
./compile_resources_linux.sh
cxfreeze xyon/main.py --target-dir=dist --target-name=xyon

