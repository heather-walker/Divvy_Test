# Divvy Data ETL
Takes a file and inserts into an AWS S3 bucket. The event triggers a lambda function with transforms the data and stores it in a DynamoDB table.


## Installation and usage
 - This pipeline runs on Python 3.7. Please use this version or update your current version.
 - This pipeline expects AWS-CLI to already be installed with a default profile that has admin access to all services in Oregon

## Steps
- Unzip Divvy_Test
    - For MacOS:

        You will need jq 1.5 to use this script. If this is not installed, please open the terminal and type

            sh ../Path_To_Unzipped_File/installdeps_macOS



    -For Windows:

        You will need jq 1.5 to use this script. If this is not installed, please open the terminal and type

        cd into the unzipped folder and run: sh installdeps_Windows.sh
        to install chocolatey and jq 1.5 

- Navigate into the unzipped folder and run the build.sh script inside using bash
cd c:\...\Divvy_Test
sh build.sh
- To confirm the test file has been inserted into the DynamoDB table, open AWS Console and navigate to DynamoDB. There should be one entry in a table called ParentChild
- To test with your own file, drag and drop into the s3 bucket called parent-child-divvy-hblood and then check the DynamoDB

## Description
- In the Divvy_Tests folder there are four shell scripts
    - build.sh:
        This file is what creates the data pipeline. It will:
        Create an S3 bucket
        Create a role and give it the correct permissions
        Create a Lambda function from the zipped file DataToJSON.zip
        Add permissions and triggers necessary for S3 and Lambda to interact
        Copy a test file into the bucket to demonstrate the pipeline. To view the results just open up your AWS Console, open DynamoDB and you should see the table ParentChild with an entry for test_text.txt.
- teardown.sh:
    This file is what cleans up the pipeline
    Deletes the bucket, row, function, and table.
- installdeps_macOS:
    This will install homebrew if you don't already have it, and jq
- installdeps_windows:
    This will install chocolatey NuGet if you don't already have it, and jq
