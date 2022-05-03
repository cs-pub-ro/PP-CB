#!/bin/bash

unzip archive.zip
unzip -qq -o artifact.zip

ghc --make Tasks.hs
find . -regex ".*\.o$" | xargs ghc --make -o main
#ghc --make main.hs
#./main

exit $?
