import json
import boto3
import os
import uuid

# AWS Servislerini tanımlayalım
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    # Terraform'da tanımladığımız environment değişkenini alıyoruz
    table_name = os.environ['DYNAMO_TABLE']
    table = dynamodb.Table(table_name)

    # Event içinden Bucket ve Dosya adını çekiyoruz
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        file_key = record['s3']['object']['key']
        file_size = record['s3']['object'].get('size', 0)

        # DynamoDB'ye kayıt atıyoruz
        table.put_item(
            Item={
                'ImageID': str(uuid.uuid4()), # Benzersiz ID
                'BucketName': bucket_name,
                'FileName': file_key,
                'Size': file_size,
                'Status': 'Processed'
            }
        )
        
    return {
        'statusCode': 200,
        'body': json.dumps('Metadata başarıyla kaydedildi!')
    }