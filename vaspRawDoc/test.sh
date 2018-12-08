#!/bin/sh

if [[ ! -f "WAVECAR" ]];then
touch cache
else
mv WAVECAR cache
fi