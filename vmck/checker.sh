#!/bin/bash

unzip archive.zip
unzip -qq -o artifact.zip

echo "*** ETAPA 3 ***"
unzip -qq -o artifact3.zip
runghc main.hs

if [ $? != 0 ]; then

    echo "*** ETAPA 1 ***"
    unzip -qq -o artifact1.zip
    runghc main.hs

    if [ $? != 0 ]; then
        echo "*** ETAPA 2 ***"
        unzip -qq -o artifact2.zip
        runghc main.hs
    fi
fi

exit $?
