#!/usr/bin/env bash

docker build -t pcmagas/arch-pkg-builder .

BRANCH=${GITHUB_REF##*/}

if [[ $BRANCH == 'master' ]]; then
    docker image push pcmagas/arch-pkg-builder:latest
fi