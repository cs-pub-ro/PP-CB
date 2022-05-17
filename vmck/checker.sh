#!/bin/bash

unzip archive.zip


echo "*** ETAPA 1 ***"
unzip -qq -o artifact1.zip
runghc main.hs

echo "*** ETAPA 2 ***"
unzip -qq -o artifact2.zip
runghc main.hs

echo "*** ETAPA 3 ***"
unzip -qq -o artifact3.zip
runghc main.hs

exit $?
