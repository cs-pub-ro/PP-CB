#!/bin/bash

unzip archive.zip
unzip -qq -o artifact.zip
runghc main.hs
exit $?
