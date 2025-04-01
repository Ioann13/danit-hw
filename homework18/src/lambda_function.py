import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    # Укажите тег, по которому будут остановлены инстансы
    tag_key = 'Owner'
    tag_value = 'Ioann'

    # Получите список запущенных инстансов с указанным тегом
    response = ec2.describe_instances(
        Filters=[
            {'Name': f'tag:{tag_key}', 'Values': [tag_value]},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )

    # Соберите ID инстансов для остановки
    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])

    if instance_ids:
        # Остановите инстансы
        ec2.stop_instances(InstanceIds=instance_ids)
        print(f"Остановленные инстансы: {instance_ids}")
    else:
        print("Нет инстансов для остановки")