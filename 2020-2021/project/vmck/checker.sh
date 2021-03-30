#!/bin/bash

unzip archive.zip

# Bring the checker here overwriting submitted files.
files=(Dataset.hs Main.hs Makefile tests)
for file in ${allThreads[@]}; do
    ln -fs "../$file"
done

make run_test
exit $?
