#!/bin/bash
BASEDIR=$(dirname $0)

${BASEDIR}/cloudformation.sh create ${BASEDIR}/templates/web-services.json ${BASEDIR}/parameters/parameters.json 
