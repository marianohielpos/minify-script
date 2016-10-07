#!/bin/bash

if [ $# -ne 2 ]; then
        echo "Usage: $0 css|js|all dir"
        exit 1
fi

if [[ $1 -ne "css" && $1 -ne "js" && $1 -ne "all" ]]; then
        echo "Unknown file type: $1. 'js', 'css' or 'all' expected"
        exit 1
fi

if [ $1 = "all" ]; then
    $0 js "$2/js"
    $0 css "$2/css"
    exit 0
fi

TYPE=$1
DIR=$2

function minify {
        echo "Minifying $DIR/$2..."
        java -jar /opt/yuicompressor/yuicompressor-2.4.8.jar --type $1 -o "${2%.$1}.min.$1" $2
}

cd $DIR

for f in *.$TYPE; do
        # Ignore .min files
        if [ -e $f ]; then
                if [[ $f != *.min.$TYPE ]]; then
                        # Does the min file exists?
                        if [ -e "${f%.$TYPE}.min.$TYPE" ]; then
                                # Only minify if the file has been modified
                                if [ $f -nt "${f%.$TYPE}.min.$TYPE" ]; then
                                        #java -jar /opt/yuicompressor/yuicompressor-2.4.8.jar --type $1 -o "${f%.$1}.min.$1" $f
                                        minify $TYPE $f
                                fi
                        else
                                #java -jar /opt/yuicompressor/yuicompressor-2.4.8.jar --type $1 -o "${f%.$1}.min.$1" $f
                                minify $TYPE $f
                        fi
                fi
        fi
done

# Apply recursively
for d in *; do
        if [ -d $d ]; then
                $0 $TYPE $d
        fi
done 

