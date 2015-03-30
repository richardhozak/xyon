#!/bin/sh

rm -rf dist
./compile_resources.sh
cxfreeze xyon/main.py --target-dir=dist --target-name=xyon
