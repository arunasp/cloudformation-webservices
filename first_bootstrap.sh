#!/bin/bash
BASEDIR=$(dirname $0)

${BASEDIR}/cloudformation.sh create ${BASEDIR}/templates/networking.json ${BASEDIR}/parameters/networking.json

[ $? -ne 0 ] && exit 1

${BASEDIR}/cloudformation.sh create ${BASEDIR}/templates/web-services.json ${BASEDIR}/parameters/parameters.json 
