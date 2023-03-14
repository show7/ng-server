#!/bin/bash

echo "🏠开始拷贝..."
PWD =$PWD
sourceDir="/Users/supreme/Documents/compony/uniapp-platform/dist/build/h5"
echo $sourceDir 
echo $PWD/www/anxinVip
cp -avx $sourceDir/* $PWD/www/anxinVip

