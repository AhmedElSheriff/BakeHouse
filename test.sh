#! /usr/bin/bash

release=$(helm list --short | grep "^bake-house")
if [[ -z $release ]] 
then
	echo 'hmmm'
else
	echo 'tttt'
fi
