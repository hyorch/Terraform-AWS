import os
import json
from random import randint
import boto3

cloudwatch = boto3.client('cloudwatch')

def lambda_handler(event, context):
    json_region = os.environ['AWS_REGION']
    #message = 'Hello {} !'.format(event['key1'])
    metricValue = randint(0,10)
    cloudwatch.put_metric_data(
        MetricData=[
            {
            'MetricName': 'nodeready',
            'Dimensions': [
            {
            'Name': 'Environment',
            'Value': 'UAT'
            },
            {
            'Name': 'Region',
            'Value': json_region
            },
            {
            'Name': 'Node',
            'Value': '2'
            }
            ],
            'Unit': 'None',
            'Value': metricValue
            }
        ],
        Namespace='Tests'
    )


    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": json_region,
            "message" : metricValue
        })
    }
