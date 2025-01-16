steps for implementation:

project 1:

- Deploy a vpc and Subnet
- Deploy the internet gateway and associate it with the pvc
- set up a rout table with a rout to the IGW and associated with the subnet
- deploy an EC2 instance inside of the created subnet and associate a public id
- associate with the public IP and security group that allows public ingress
- change the Ec2 instance to use a publicly available NGINX AMI

at first I shoud run below command:
source .env

terraform state list -> gives us all the resources that terraform manage in current project



