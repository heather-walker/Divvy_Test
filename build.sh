#!/bin/bash

# Create a bucket
ECHO "Welcome to the data transformer!"
ECHO
ECHO "First, I need to make a new bucket."
aws s3api create-bucket --bucket parent-child-divvy-hblood --region us-west-2 \
 --create-bucket-configuration LocationConstraint=us-west-2
# Create the s3 lambda role
ECHO
ECHO "I am also creating a new role."
aws iam create-role --role-name "lambda-s3-role" \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
        ]
    }'
ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
# add S3 policy to the created role
ECHO
ECHO "Adding Admin Access to the new role."
aws iam attach-role-policy \
  --role-name "lambda-s3-role" \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
# ECHO
# ECHO "Adding CloudTrail Access to the new role"
# aws iam attach-role-policy \
  # --role-name "lambda-s3-role" \
  # --policy-arn arn:aws:iam::aws:policy/AWSCloudTrailFullAccess
# ECHO
# ECHO "Adding DynamoDB Access to the new role"
# aws iam attach-role-policy \
  # --role-name "lambda-s3-role" \
  # --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess
# ECHO
# ECHO "Adding Lambda Access to the new role"
  # aws iam attach-role-policy \
  # --role-name "lambda-s3-role" \
  # --policy-arn arn:aws:iam::aws:policy/AWSLambdaFullAccess
# Create the lambda function
ECHO
ECHO "Now I need to create a lambda function to transform the data..."
LAMBDA="DataToJSON"
aws lambda create-function --function-name $LAMBDA  \
     --runtime "python3.7" --role "arn:aws:iam::$ACCOUNT_ID:role/lambda-s3-role" \
     --handler "DataToJSON.lambda_handler" --timeout 3 \
     --memory-size 128 \
     --zip-file "fileb://DataToJSON.zip"
# add s3 permission to lambda function
ECHO
ECHO "Adding S3 permissions to invoke the function"
aws lambda add-permission --function-name $LAMBDA \
 --statement-id "s3-put-event-us-west-2" --action "lambda:InvokeFunction"\
 --principal "s3.amazonaws.com" --source-arn "arn:aws:s3:::parent-child-divvy-hblood" \
 --region us-west-2
FUNCTION_ARN="arn:aws:lambda:us-west-2:$ACCOUNT_ID:function:$LAMBDA"
VAR1='{
       "LambdaFunctionConfigurations": [
       {
         "Id": "s3-event-triggers-lambda",
         "LambdaFunctionArn": "'
VAR2='",
         "Events": ["s3:ObjectCreated:Put"]
         }
     ]
   }'
ECHO "$VAR1$FUNCTION_ARN$VAR2"
# Adding trigger to new lambda function
ECHO
ECHO "Adding lambda trigger lambda function"
aws s3api put-bucket-notification-configuration --bucket "parent-child-divvy-hblood" \
   --notification-configuration "$VAR1$FUNCTION_ARN$VAR2"
# Copying new file into the bucket
ECHO
ECHO "Using test file to run function. "
aws s3 cp test_text.txt

ECHO
ECHO "Process complete!"