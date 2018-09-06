#!/bin/bash

WD=`pwd`
for ff in `find . -maxdepth 5 -name .git`
do
    GDIR=`dirname $ff`
    cd $WD/$GDIR
    echo $GDIR
    git st -s
    git st | grep ahead
done
cd $WD
