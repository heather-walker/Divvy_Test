# Divvy Data ETL 
Takes a file and inserts into an AWS S3 bucket. The event triggers a lambda function with transforms the data and stores it in a DynamoDB table.
## Installation and usage

- Unzip Divvy_Test
  - cd into the unzipped folder, cd into Scripts, and run the build.sh script inside
```bash
cd c:\...\Divvy_Test
cd Scripts
sh build.sh
```
- To confirm the test file has been inserted into the DynamoDB table, open AWS Console and navigate to DynamoDB. There should be one entry in a table called ParentChild

To test with your own file, drag and drop into the s3 bucket called parent-child-divvy-hblood and then check the DynamoDB

## Description
  ### In the `Scripts` folder there is one shell script
- `build.sh`:  
    - This file is what creates the data pipeline.  It will:  
         - Create an S3 bucket
         - Create a role and give it the correct permissions
         - Create a Lambda function from the zipped file `DataToJSON.zip`
         - Add permissions and triggers necessary for S3 and Lambda to interact
        - Copy a test file into the bucket to demonstrate the pipeline.  To view the results just open up your AWS Console, open DynamoDB and you should see the table `ParentChild` with an entry for `test_text.txt`.


