#!/bin/bash
BASEDIR=$(dirname $0)

${BASEDIR}/cloudformation.sh delete ${BASEDIR}/templates/web-services.json ${BASEDIR}/parameters/parameters.json 
[ $? -ne 0 ] && exit 1

${BASEDIR}/cloudformation.sh delete ${BASEDIR}/templates/networking.json ${BASEDIR}/parameters/networking.json
