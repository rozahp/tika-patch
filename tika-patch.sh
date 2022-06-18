#!/bin/bash
##
## Filename:        tika-patch.sh
##
## Description:     Removes language detection from tika-server-1.1[78].jar to speed things up.
##
 
SOURCE="org/apache/tika/server/resource"
JARFILE=$1

echo "INFO: removing language detection from Apache Tika Server"

##
## ERROR CHECKING
##

if [ "a"$1 == "a" ]; then
    echo "ERROR: arguments: tika-patch.sh tika-server-*.jar"
    exit
fi

if [ "a"`which zip` == "a" ]; then 
    echo "ERROR: zip not found - please install program!"
    exit
fi

JAR=`echo $JARFILE | tr "." " " | awk '{ print $NF }'`

if [ ! "a"$JAR == "ajar" ]; then
    echo "ERROR: is this really a jarfile: $JARFILE ?"
    exit
fi

if [ ! -f $JARFILE ]; then
    echo "ERROR: $JARFILE not found!"
    exit
fi

if [ ! -d $SOURCE ]; then
    echo "ERROR: unable to find directory: $SOURCE"
    exit
fi

##
## UPDATE JAR FILE
##

echo "INFO: updating jar-file with patched class-files ..."

cp $JARFILE $JARFILE".patched.jar"

zip -qq -u $JARFILE".patched.jar" $SOURCE/*.class

##
## DONE
##

echo "INFO: Done! Try: $JARFILE.patched.jar"

##
## EOF
##
