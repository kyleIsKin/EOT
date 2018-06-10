#!/bin/bash
#
# eotio-tn_roll is used to have all of the instances of the EOTS daemon on a host brought down
# so that the underlying executable image file (the "text file") can be replaced. Then
# all instances are restarted.
# usage: eotio-tn_roll.sh [arglist]
# arglist will be passed to the node's command line. First with no modifiers
# then with --replay and then a third time with --resync
#
# The data directory and log file are set by this script. Do not pass them on
# the command line.
#
# In most cases, simply running ./eotio-tn_roll.sh is sufficient.
#

if [ -z "$eotIO_HOME" ]; then
    echo eotIO_HOME not set - $0 unable to proceed.
    exit -1
fi

cd $eotIO_HOME

if [ -z "$eotIO_NODE" ]; then
    DD=`ls -d var/lib/node_[012]?`
    ddcount=`echo $DD | wc -w`
    if [ $ddcount -gt 1 ]; then
        DD="all"
    fi
    OFS=$((${#DD}-2))
    export eotIO_NODE=${DD:$OFS}
else
    DD=var/lib/node_$eotIO_NODE
    if [ ! \( -d $DD \) ]; then
        echo no directory named $PWD/$DD
        cd -
        exit -1
    fi
fi

prog=""
RD=""
for p in eotd eotiod nodeot; do
    prog=$p
    RD=bin
    if [ -f $RD/$prog ]; then
        break;
    else
        RD=programs/$prog
        if [ -f $RD/$prog ]; then
            break;
        fi
    fi
    prog=""
    RD=""
done

if [ \( -z "$prog" \) -o \( -z "$RD" \) ]; then
    echo unable to locate binary for eotd or eotiod or nodeot
    exit 1
fi

SDIR=staging/EOTS
if [ ! -e $SDIR/$RD/$prog ]; then
    echo $SDIR/$RD/$prog does not exist
    exit 1
fi

if [ -e $RD/$prog ]; then
    s1=`md5sum $RD/$prog | sed "s/ .*$//"`
    s2=`md5sum $SDIR/$RD/$prog | sed "s/ .*$//"`
    if [ "$s1" == "$s2" ]; then
        echo $HOSTNAME no update $SDIR/$RD/$prog
        exit 1;
    fi
fi

echo DD = $DD

bash $eotIO_HOME/scripts/eotio-tn_down.sh

cp $SDIR/$RD/$prog $RD/$prog

if [ $DD = "all" ]; then
    for eotIO_RESTART_DATA_DIR in `ls -d var/lib/node_??`; do
        bash $eotIO_HOME/scripts/eotio-tn_up.sh $*
    done
else
    bash $eotIO_HOME/scripts/eotio-tn_up.sh $*
fi
unset eotIO_RESTART_DATA_DIR

cd -
