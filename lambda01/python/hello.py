import os
import json
        
def lambda_handler(event, context):
    json_region = os.environ['AWS_REGION']
    message = 'Hello {} !'.format(event['key1'])
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": json_region,
            "message" : message
        })
    }
