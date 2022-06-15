import boto3
import os
import requests #Import module into this directory -- pip install requests -t ./
from requests.structures import CaseInsensitiveDict
import json
cloudwatch = boto3.client('cloudwatch')
def lambda_handler(event, context):
    REGION = os.environ['AWS_REGION']
    print(REGION)
    url = "https://reqbin.com/echo/get/json"
    headers = CaseInsensitiveDict()
    headers["Accept"] = "application/json"
    resp = requests.get(url, headers=headers)
    data = resp.json()
    if data['success'] == 'true':
        metricValue = 1
    else:
        metricValue = 0
    print (metricValue)
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
                'Value': REGION
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
        'statusCode': 200,
        'body': 'metric published'
    }

def demo_run():  
    url = "https://reqbin.com/echo/get/json"
    headers = CaseInsensitiveDict()
    headers["Accept"] = "application/json"
    resp = requests.get(url, headers=headers)
    data = resp.json()
    if data['success'] == 'true':
        metricValue = 1
    else:
        metricValue = 0
    print (metricValue)
    
    return {
        'statusCode': 200,
        'body': 'metric published'
    }

if __name__ == "__main__":
    demo_run()