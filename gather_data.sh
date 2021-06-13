#!/bin/bash
mkdir data
cd data
mkdir raw
cd raw
wget -r ftp://parrot.genomics.cn/gigadb/pub/10.5524/100001_101000/100295/*
cd parrot.genomics.cn/gigadb/pub/10.5524/100001_101000/100295/
mv * ../../../../../../
cd ../../../../../../
rm -rf parrot.genomics.cn/
