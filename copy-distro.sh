#!/bin/sh

src=${1%%\/}
dst=${2%%\/}

#src=/home/builder/sqa/maindistro/ubicom-distro
#dst=/home/builder/sqa/maindistro/ubicom-distro-git

#cd $src; git pull && ./git_all pull

#if [ $? != 0 ]
#	then exit 1
#fi

#./git_all gc --aggressive

#rm -rf $dst

files="./.git "$(cd $src; git submodule --quiet foreach echo '$path'"/.git"; cd uClinux; git submodule --quiet foreach echo "uClinux/"'$path'"/.git"; cd ..)

for i in $files; do
 if [ ! -d "`dirname $dst/$i`/." ]
 then
  echo "Creating directory $i"
  mkdir -p "`dirname $dst/$i`/." || exit 1
 fi
 echo "Copying $src/$i to $dst/$i"
 cp -af $src/$i $dst/$i
done

