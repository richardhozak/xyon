#!/bin/sh

echo "Compiling resources..."

pyrcc5 xyon/images/images.qrc -o xyon/images/resources.py
head -n -1 xyon/images/resources.py > temp
mv temp xyon/images/resources.py

pyrcc5 xyon/ui/ui.qrc -o xyon/ui/resources.py
head -n -1 xyon/ui/resources.py > temp
mv temp xyon/ui/resources.py

echo "Resources compiled."
