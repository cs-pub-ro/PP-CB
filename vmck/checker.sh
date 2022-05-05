#!/bin/bash

unzip archive.zip
unzip -qq -o artifact.zip

free -h

ghc --make Tasks.hs
find . -regex ".*\.o$" | xargs ghc --make -o main
timeout 5 ghc --make main.hs
echo "here"
./main

exit $?
