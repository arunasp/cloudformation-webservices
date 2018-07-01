#!/bin/bash
BASEDIR=$(dirname $0)

${BASEDIR}/cloudformation.sh create ${BASEDIR}/templates/networking.json ${BASEDIR}/parameters/networking.json
