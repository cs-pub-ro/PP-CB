#!/bin/bash

unzip archive.zip
unzip -qq -o artifact.zip
make run_test
exit $?
