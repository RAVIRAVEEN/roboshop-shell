#!/bin/bash

AMI="ami-03265a0778a880afb"
SG_ID="sg-02deaf6b5f3dd44c0"
INSTANCES_ID=("mongodb" "mysql" "redis" "cart" "user" "catalogue" "payment" "shipping"  "rabbitmq" "dispatch" "web")
HOSTED_ID="Z05755302BISQRJNR4ESX"
DOMAIN_NAME="devopsrank.online"


for i in  "${INSTANCES_ID[0]}"
do 
   echo "instance= $1"

   if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
   then 
   instance_type="t3.small"
   else
   instance_type="t2.micro"
   fi

   IP_address=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $instance_type --security-group-ids sg-02deaf6b5f3dd44c0 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" --query 'Instance[0], privateIpAddress' --output text)


 #create r53 record , make sure you delete existing record
aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ID \
  --change-batch '
  {
    "Comment": "Testing creating a record set"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "$i.$DOMAIN_NAME"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "$IP_address"
        }]
      }
    }]
  }
  ,
   done
