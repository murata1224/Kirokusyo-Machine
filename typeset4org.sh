#!/bin/sh
echo $1
filename=`echo $1 | sed -e "s/\.tex//"`
echo "filename is $filename"
platex $filename
platex $filename
dvipdfmx $filename
