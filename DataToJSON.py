import json
import boto3
import sys
import os
import time

s3_client = boto3.client('s3')
db_client = boto3.client('dynamodb')

def lambda_handler(event, context):
    if event:
        new_file_obj = event['Records'][0]

        bucket_name =  new_file_obj['s3']['bucket']['name']
        file_name = new_file_obj['s3']['object']['key']
                
        s3_file = s3_client.get_object(Bucket=bucket_name, Key=file_name)
        file_content = s3_file['Body'].read().decode('utf-8').split(",")

        unique_parents, all_parents, all_children = find_parents(file_content)

        #for each parent in total list, create dictionary with parent name and all related child values
        database = []
        for parent in unique_parents:
            parent_dicts = {'name':parent, 'children': find_all_children(parent, all_parents, all_children)}
            database.append(parent_dicts)
        
        upload_to_database(file_name, database, 'ParentChild')

def find_parents(data):
    #find all last words in each statement (parents)
    all_parents = [item.split()[-1] for item in data]

    #find all first words in each statement (childen)
    all_children = [item.split()[0] for item in data]

    #create master list of all child and parents remove duplicates to create all unique parents
    unique_parents = list(dict.fromkeys([item.split()[0] for item in data] + [item.split()[-1] for item in data]))

    return unique_parents, all_parents, all_children

#find each index of occurances of a given parent, find each child with the same index and 
#create child list
def find_all_children(value, parent, child):
    indices = [i for i, x in enumerate(parent) if x == value]
    child_list = []
    for i in indices:
        child_list.append(child[i])
    return (child_list)

def upload_to_database(file_name, database, table_name):
    TABLE_NAME = table_name

    # Create a table in DynamoDB that has a name attribute
    try:
        response = db_client.create_table(
            TableName=TABLE_NAME,
            KeySchema=[
                {
                    'AttributeName': 'FileName',
                    'KeyType': 'HASH'
                },
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'FileName',
                    'AttributeType': 'S'
                },
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            },
        )
    except:
        print('Table has already been created')

    time.sleep(1)

    # Write out to the table
    response = db_client.put_item(
        TableName=TABLE_NAME,
        Item={
            'FileName': {
                'S': file_name,
            },
            'data': {
                'S': json.dumps(database),
            }
        }
    )
    
    
