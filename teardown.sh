#!/bin/bash
ECHO 'Cleaning up.'
ECHO
ECHO 'Emptying bucket.'
aws s3 rm s3://parent-child-divvy-hblood --recursive
ECHO
ECHO 'Deleting bucket.'
aws s3api delete-bucket --bucket parent-child-divvy-hblood
ECHO
ECHO 'Detaching policies.'
aws iam detach-role-policy --role-name lambda-s3-role --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
ECHO
ECHO 'Deleting role.'
aws iam delete-role --role-name lambda-s3-role
ECHO
ECHO 'Deleting function.'
aws lambda delete-function --function-name DataToJSON
ECHO
ECHO 'Deleting table.'
aws dynamodb delete-table --table-name ParentChild
ECHO
ECHO 'All done!'