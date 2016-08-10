#!/bin/sh

echo "test script arguments..."

if [  "$1" ];then
  echo -e "1. arg, $1"
fi

if [ "$2" ];then
  echo -e "2. arg, $2"
fi


exit 0
