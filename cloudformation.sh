#!/bin/bash

## Cloudformation scripted stack control

AWS_CLI=$(which aws)

function validate_template() {

 $AWS_CLI cloudformation validate-template --template-body "file://$1"
}

function create_stack() {

 echo "Creating stack $1"
 $AWS_CLI cloudformation create-stack --stack-name "$1" --template-body  "file://$2" --parameters "file://$3"
 STACK_STATE=$(check_stack_status $StackName 2>&1)
 while [ "$STACK_STATE" == "CREATE_IN_PROGRESS" ]
 do
   echo -n '.'
   STACK_STATE=$(check_stack_status $StackName 2>&1)
   sleep 5
 done
 echo ""
 if [ "$STACK_STATE" != "CREATE_COMPLETE" ]
 then
	echo "Failed to create stack. The result code: $STACK_STATE"
	echo "Please check AWS CloudFormation Console for details."
 	exit 1
 else
	echo "Finished successfully."
 fi

}

function update_stack() {

 echo "Updating stack $1"
 $AWS_CLI cloudformation update-stack --stack-name "$1" --template-body  "file://$2" --parameters "file://$3"
 STACK_STATE=$(check_stack_status $StackName 2>&1)
 while [ "$STACK_STATE" == "UPDATE_IN_PROGRESS" -o "$STACK_STATE" == "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS" ]
 do
   echo -n '.'
   STACK_STATE=$(check_stack_status $StackName 2>&1)
   sleep 5
 done
 echo ""
 if [ "$STACK_STATE" != "UPDATE_COMPLETE" ]
 then
	echo "Failed to create stack. The result code: $STACK_STATE"
	echo "Please check AWS CloudFormation Console for details."
 	exit 1
 else
	echo "Finished successfully."
 fi
}

function delete_stack() {

 echo -n "Deleting stack $1 ..."
 $AWS_CLI cloudformation delete-stack --stack-name "$1"
 STACK_STATE=$(check_stack_status $StackName 2>&1)
 while [ "$STACK_STATE" == "DELETE_IN_PROGRESS" ]
 do
   echo -n '.'
   STACK_STATE=$(check_stack_status $StackName 2>&1)
   sleep 5
 done
 echo ""
 echo "Finished successfully."

}

function check_stack_status() {
 $AWS_CLI cloudformation describe-stacks --stack-name $1 --output text --query 'Stacks[*].StackStatus'
}

function help() {
  echo "Usage: $0 validate|status|create|update|delete /path/to/template /path/to/template_parameters"
  exit 0
}


[ -z $2 ] && help

if [ -z "$AWS_CLI" ]
then
 echo "Could not find AWS CLI command. Is python-awscli installed?"
 exit 1
fi

$AWS_CLI s3 ls > /dev/null
if [ $? -ne 0 ]
then
 echo "Could not access AWS S3. Is aws-cli configured and aws_access_key_id/aws_secret_access_key have permissions to AWS?"
 exit 1
fi

# Resolve template path
dirname "$2" | grep -q "^\."
[ $? -eq 0 ] && template="$(pwd)/$2" || template="$2"

# Resolve template parameters path
[ -z $3 ] && parameters="$(pwd)/parameters/parameters.json" || parameters="$3"
dirname "$parameters" | grep -q "^\."
[ $? -eq 0 ] && parameters="$(pwd)/$parameters"

# Resolve Stack name from parameters file
StackName=$(grep -A 1 '"StackName"' $parameters  | grep "ParameterValue" | cut -f 4 -d'"')
if [ -z "$StackName" ]
then
  echo "Could not resolve stack name in parameters file. Please check StackName parameter"
  exit 1
fi

case $1 in
  validate) validate_template $template;;
  status) check_stack_status $StackName;;
  create) create_stack $StackName $template $parameters;;
  update) update_stack $StackName $template $parameters;;
  delete) delete_stack $StackName $template $parameters;;
  *) help ;;
esac
