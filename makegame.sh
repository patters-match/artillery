#!/bin/bash

# this script is intended to be invoked by a Sublime build scipt

# pass the code filename to be compiled as the first parameter ($file)
# pass the code base filename (without extension) the second parameter ($file_base_name)
# pass the code working folder name as the third parameter ($file_path)

# uses zmakebas from https://github.com/ohnosec/zmakebas

file=$1
file_base_name=$2
file_path=$3
tmp=/tmp/artillery

mkdir -p ${tmp}
rm -f ${tmp}/*.bas ${tmp}/*.tap

echo "~~~SCREEN~~~"
z88dk-appmake +zx -b ${file_path}/cannon5.scr -o ${tmp}/screen.tap --org 16384 --blockname arti.scr --noloader || exit

echo "~~~GAME~~~"
zmakebas -n arti.bas -o ${tmp}/game.tap -a @udg -i 10 -l $file || exit

echo "~~~LOADER~~~"
cat > ${tmp}/loader.bas << _BASIC_
   10 BORDER 0: PAPER 0: INK 7: CLS
   20 FOR n=1 TO 5: BEEP .1,n: NEXT n
   30 PRINT AT 9,6; INK 7; BRIGHT 1;"ARTILLERY IS LOADING";AT 11,10; INVERSE 1;"PLEASE WAIT"
   40 PRINT AT 0,0
   50 LOAD "arti.scr"SCREEN$
   60 INK 0: PRINT AT 3,0
   70 LOAD "arti.bas"
_BASIC_
zmakebas -n Artillery -o ${tmp}/loader.tap -a 10 ${tmp}/loader.bas || exit

echo "~~~TAPE~~~"
# assemble the TAP file from the blocks
cat ${tmp}/loader.tap ${tmp}/screen.tap ${tmp}/game.tap > ${file_path}/${file_base_name}.tap
