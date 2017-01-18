provider "aws" {
  access_key = "AKIAICPATSPOC2NSVNQQ"
  secret_key = "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"
  region = "eu-west-1"
}

resource "aws_cloudformation_stack" "esstack" {
  name = "elasticsearch-stack"

  template_body = <<STACK
    {
	"AWSTemplateFormatVersion": "2010-09-09",
	"Description": "This template creates a Stack on AWS CloudFormation for provisioning 3 servers in cluster.",
	"Parameters": {
		"VPCCIDR": {
			"Type": "String",
			"Description": "First Three Octates of VPC CIDR Block separated with dot(.).",
			"Default": "10.0.1",
			"ConstraintDescription": "must be a valid First Two Ocates of IP CIDR range of the form x.x.x ."
		},
		"PublicSubnetAZ1": {
			"Type": "String",
			"Description": "CIDR for Public Subnet to be created in AZ1.",
			"Default": "10.0.1.0/28",
			"ConstraintDescription": "Must be a valid value of CIDR."
		},
		"PublicSubnetAZ2": {
			"Type": "String",
			"Description": "CIDR for Public Subnet to be created in AZ2",
			"Default": "10.0.1.16/28",
			"ConstraintDescription": "Must be a valid value of CIDR."
		},
   
        "PublicSubnetAZ3": {
			"Type": "String",
			"Description": "CIDR for Public Subnet to be created in AZ2",
			"Default": "10.0.1.32/28",
			"ConstraintDescription": "Must be a valid value of CIDR."
		},

		"TagVPCName": {
			"Type": "String",
			"Default": "ElasticVPC",
			"Description": "Please enter value for VPC Tag 'Name' Here."
		},

		"TagServiceOwner": {
			"Description": "This value must be an valid existing email address who owns the Product or Platform.",
			"Type": "String",
			"MinLength": "1",
			"MaxLength": "255",
			"Default": "abdul_nayeem2002@yahoo.com",
			"ConstraintDescription": "Typically should be user email ID"
		},
		
		"TagServiceName": {
			"Description": "Value of Instance TAG with key as ServiceName.",
			"Type": "String",
			"MinLength": "1",
			"MaxLength": "255",
			"Default": "ElasticSearch",
			"ConstraintDescription": "Fundamentally used to determine which project this corresponds to."
		}

	},

	"Mappings": {
		"AWSSVNAMI": {
			"eu-west-1": {
				"AMI": "ami-b9b394ca"
			}
		}
	},

	"Resources": {
		"VPC": {
			"Type": "AWS::EC2::VPC",
			"Properties": {
				"CidrBlock": {
					"Fn::Join": ["",[{"Ref": "VPCCIDR"},".0/24"]]
				},
				"InstanceTenancy": "default",
				"Tags": [{
							"Key": "Name",
							"Value": {"Ref": "TagVPCName"}
						},

						{
							"Key": "ServiceName",
							"Value": {"Ref": "TagServiceName"}
						},

						{
							"Key": "ServiceOwner",
							"Value": {"Ref": "TagServiceOwner"}
						}]
			}
		},

		"PublicRouteTable": {
			"Type": "AWS::EC2::RouteTable",
			"Properties": {
				"VpcId": {"Ref": "VPC"},

				"Tags": [{
						"Key": "Name",
						"Value": "Public Access Route Table"
						},

						{
						"Key": "ServiceOwner",
						"Value": {"Ref": "TagServiceOwner"}
						},

						{
						"Key": "ServiceName",
						"Value": {"Ref": "TagServiceName"}
						}]
			}
		},
		
		"InternetGateway": {
			"Type": "AWS::EC2::InternetGateway",
			"Properties": {
				"Tags": [{
						"Key": "Name",
						"Value": {"Fn::Join": ["",["Internet Gateway for VPC ",{"Ref": "VPC"}] ]}
			        	},

						{
						"Key": "ServiceName",
						"Value": {"Ref": "TagServiceName"}
						},

						{
						"Key": "ServiceOwner",
						"Value": {"Ref": "TagServiceOwner"}
						}]
			}
		},

		"AttachGateway": {
			"Type": "AWS::EC2::VPCGatewayAttachment",
			"DependsOn": ["VPC","InternetGateway"],
			"Properties": {
				"VpcId": {"Ref": "VPC"},
				"InternetGatewayId": {"Ref": "InternetGateway"}
				}
		},

		"IGWRouteforPublicRT": {
			"Type": "AWS::EC2::Route",
			"DependsOn": "AttachGateway",
			"DependsOn": "InternetGateway",
			"Properties": {
				"RouteTableId": {"Ref": "PublicRouteTable"},
				"DestinationCidrBlock": "0.0.0.0/0",
				"GatewayId": { "Ref": "InternetGateway"}
				}
		},
		
		"PublicSubnet1": {
			"Type": "AWS::EC2::Subnet",
			"Properties": {
				"VpcId": {"Ref": "VPC"},

				"CidrBlock": {"Ref": "PublicSubnetAZ1"},

				"AvailabilityZone": {"Fn::Select": [0,{"Fn::GetAZs": ""}]},

				"Tags": [{
						"Key": "Tier",
						"Value": "Public Tier"
						},

						{
						"Key": "Name",
						"Value": "Public Subnet1"
						},

						{
						"Key": "ServiceName",
						"Value": {"Ref": "TagServiceName"}
						}]
			}
		},

		"PublicSubnet2": {
			"Type": "AWS::EC2::Subnet",
			"Properties": {
				"VpcId": {"Ref": "VPC"},
				"CidrBlock": {"Ref": "PublicSubnetAZ2"},
				"AvailabilityZone": {"Fn::Select": [1,{"Fn::GetAZs": ""}]},
				"Tags": [{
					"Key": "Tier",
					"Value": "Public Tier"
				},

				{
					"Key": "Name",
					"Value": "Public Subnet2"
				},

				{
					"Key": "ServiceName",
					"Value": {"Ref": "TagServiceName"}
				}]
			}
		},

		"PublicSubnet3": {
			"Type": "AWS::EC2::Subnet",
			"Properties": {
				"VpcId": {"Ref": "VPC"},
				"CidrBlock": {"Ref": "PublicSubnetAZ3"},
				"AvailabilityZone": {"Fn::Select": [2,{"Fn::GetAZs": ""}]},
				"Tags": [{
					"Key": "Tier",
					"Value": "Public Tier"
				},

				{
					"Key": "Name",
					"Value": "Public Subnet3"
				},

				{
					"Key": "ServiceName",
					"Value": {"Ref": "TagServiceName"}
				}]
			}
		},

		"PublicSubnet1PublicRTAssociation": {
			"Type": "AWS::EC2::SubnetRouteTableAssociation",
			"Properties": {
				"SubnetId": {"Ref": "PublicSubnet1"},
				"RouteTableId": {"Ref": "PublicRouteTable"}
			}
		},

		"PublicSubnet2PublicRTAssociation": {
			"Type": "AWS::EC2::SubnetRouteTableAssociation",
			"Properties": {
				"SubnetId": {"Ref": "PublicSubnet2"},
				"RouteTableId": {"Ref": "PublicRouteTable"}
			}
		},

		"PublicSubnet3PublicRTAssociation": {
			"Type": "AWS::EC2::SubnetRouteTableAssociation",
			"Properties": {
				"SubnetId": {"Ref": "PublicSubnet3"},
				"RouteTableId": {"Ref": "PublicRouteTable"}
			}
		},

		"PublicNACL": {
			"Type": "AWS::EC2::NetworkAcl",
			"Properties": {
				"VpcId": {"Ref": "VPC"},

				"Tags": [{
						"Key": "Name",
						"Value": "Public tier NACL"
						},

						{
						"Key": "ServiceName",
						"Value": {"Ref": "TagServiceName"}
						},

						{
						"Key": "ServiceOwner",
						"Value": {"Ref": "TagServiceOwner"}
						},
				
						{
						"Key": "ParentCIDR",
						"Value": {"Fn::Join": ["",[{"Ref": "VPCCIDR"},".1.0/24"]]}
						}]
			}
		},

		"PublicSubnet1NACLAssociation": {
			"Type": "AWS::EC2::SubnetNetworkAclAssociation",
			"Properties": {
				"NetworkAclId": {"Ref": "PublicNACL"},
				"SubnetId": {"Ref": "PublicSubnet1"}
			}
		},

		"PublicSubnet2NACLAssociation": {
			"Type": "AWS::EC2::SubnetNetworkAclAssociation",
			"Properties": {
				"NetworkAclId": {"Ref": "PublicNACL"},
				"SubnetId": {"Ref": "PublicSubnet2"}
			}
		},

		"PublicSubnet3NACLAssociation": {
			"Type": "AWS::EC2::SubnetNetworkAclAssociation",
			"Properties": {
				"NetworkAclId": {"Ref": "PublicNACL"},
				"SubnetId": {"Ref": "PublicSubnet3"}
			}
		},

    	"IBEntry1forPubTierNACL" : {
      		"Type" : "AWS::EC2::NetworkAclEntry",
      		"Properties" : {
        		"NetworkAclId" : {
          			"Ref" : "PublicNACL"
        		},
        	"RuleNumber" : "100",
        	"Protocol" : "6",
        	"RuleAction" : "allow",
        	"Egress" : "false",
        	"CidrBlock" : "142.252.0.0/16",
        	"PortRange" : {
          		"From" : "22",
          		"To" : "22"
        		}
      		}
    	},

   		"IBEntry2forPubTierNACL" : {
      		"Type" : "AWS::EC2::NetworkAclEntry",
      		"Properties" : {
        		"NetworkAclId" : {
          			"Ref" : "PublicNACL"
        		},
        	"RuleNumber" : "110",
        	"Protocol" : "6",
        	"RuleAction" : "allow",
        	"Egress" : "false",
        	"CidrBlock" : "0.0.0.0/0",
        	"PortRange" : {
          		"From" : "80",
          		"To" : "80"
        		}
      		}
    	},


    	"IBEntry3forPubTierNACL" : {
      		"Type" : "AWS::EC2::NetworkAclEntry",
      		"Properties" : {
        		"NetworkAclId" : {
          			"Ref" : "PublicNACL"
        		},
        	"RuleNumber" : "120",
        	"Protocol" : "6",
        	"RuleAction" : "allow",
        	"Egress" : "false",
        	"CidrBlock" : "10.0.0.0/8",
        	"PortRange" : {
         		 "From" : "1024",
          		 "To" : "65535"
        		}
      		}
    	},

    	"IBEntry4forPubTierNACL" : {
      		"Type" : "AWS::EC2::NetworkAclEntry",
      		"Properties" : {
        		"NetworkAclId" : {
          			"Ref" : "PublicNACL"
        		},
        	"RuleNumber" : "130",
        	"Protocol" : "17",
        	"RuleAction" : "allow",
        	"Egress" : "false",
        	"CidrBlock" : "10.0.0.0/8",
        	"PortRange" : {
         		 "From" : "1024",
          		 "To" : "65535"
        		}
      		}
    	},								

   	    "OBEntry1forPubTierNACL" : {
      		"Type" : "AWS::EC2::NetworkAclEntry",
      		"Properties" : {
        		"NetworkAclId" : {
          			"Ref" : "PublicNACL"
        		},
        	"RuleNumber" : "100",
        	"Protocol" : "-1",
        	"RuleAction" : "allow",
        	"Egress" : "true",
        	"CidrBlock" : "0.0.0.0/0"
      		}
        },
       

    	"ElasticServer1": {
			"Type": "AWS::EC2::Instance",
			"Properties": {
				"ImageId": {"Fn::FindInMap": ["AWSSVNAMI", {"Ref": "AWS::Region"},"AMI"]},
				"InstanceType": "t2.micro",
				"UserData": {
					"Fn::Base64": {
						"Fn::Join": [
							"", [
								"#!/bin/bash -v \n",
								"apt-get update -y\n",
								"apt-get install apache2 -y\n",
								"service apache2 start\n",
								"apt-get install -y awscli"
							    ]
						]
					}
				},
 				
 				"NetworkInterfaces" : [{
                 	"AssociatePublicIpAddress" : "True",
                	"DeleteOnTermination" : "True",
                 	"SubnetId" : { "Ref" : "PublicSubnet1" },
                 	"DeviceIndex" : "0",
                 	"GroupSet" : [ { "Ref" : "LinuxServerSecurityGroup" } ]
            	}],

				"KeyName": "staginges",
				"Tags": [{
					"Key": "Name",
					"Value": "esubuntu01"
					},  
				    {
					"Key": "Hostname",
					"Value": "esubuntu01"
					},
				    {
					"Key": "ServiceName",
					"Value": {"Ref": "TagServiceName"}
					},  
					{
					"Key": "ServiceOwner",
					"Value": {"Ref": "TagServiceOwner"}
				    } 
				    ]
			}
		},

		"LinuxServerSecurityGroup": {
			"Type": "AWS::EC2::SecurityGroup",
			"Properties": {
				"GroupDescription": "LinuxServer",
				"VpcId": {
					"Ref": "VPC"
				},
				"SecurityGroupEgress": [],
				"SecurityGroupIngress": [
				{
					"IpProtocol": "tcp",
					"FromPort": "22",
					"ToPort": "22",
					"CidrIp": "143.252.191.99/32"
				},
				{
					"IpProtocol": "tcp",
					"FromPort": "80",
					"ToPort": "80",
					"CidrIp": "0.0.0.0/0"
				},
				{
					"IpProtocol": "tcp",
					"FromPort": "9200",
					"ToPort": "9200",
					"CidrIp": "0.0.0.0/0"
				}],
				"Tags" : [{
					"Key": "Name",
					"Value": "esubuntu01"
					}]  
			}
		},


		"ESELB" : {

            "Type" : "AWS::ElasticLoadBalancing::LoadBalancer",
            "Properties": { 
                 "Subnets" : [{"Ref" :"PublicSubnet1"}],

                 "Listeners" : [ {
                      "LoadBalancerPort" : "80",
                      "InstancePort" : "TCP",
                      "InstancePort" : "80",
                      "Protocol" : "TCP"
                      }
                 ],

                 "HealthCheck" : {
                     "Target" : "HTTP:80/",
                     "HealthyThreshold" : "3",
                     "UnhealthyThreshold" : "5",
                     "Interval" : "30",
                     "Timeout" : "5"
                 },
                 "Scheme" : "internet-facing",
                 "Instances" : [{"Ref" : "ElasticServer1"}],
                 
                 "SecurityGroups" : [{"Ref" : "LinuxServerSecurityGroup"}],
                 "Tags": [
                        {
                        "Key": "Name",
                        "Value": "ElasticSearch ELB"
                        },
                        {
                        "Key": "ServiceOwner",
                        "Value": {"Ref": "TagServiceOwner"}
                        },
                        {
                        "Key": "ServiceName",
                        "Value": {"Ref": "TagServiceName"}
                        }
                        ]

             }
        }

	},
	"Outputs": {
		"VPCID": {
			"Description": "VPC ID provisioned through this Stack.",
			"Value": {"Ref": "VPC"}
			},
		"PublicSubnetAZ1": {
			"Description": "Public Subnet ID for Availability Zone 1 ",
			"Value": {"Ref": "PublicSubnet1"}
			},
		"PublicSubnetAZ2": {
			"Description": "Public Subnet ID for Availability Zone 2 ",
			"Value": {	"Ref": "PublicSubnet2"}
			},

		"PublicSubnetAZ3": {
			"Description": "Public Subnet ID for Availability Zone 2 ",
			"Value": {	"Ref": "PublicSubnet3"}
			},

		"PublicNACLS": {
			"Description": "Public Tier Network ACL ID ",
			"Value": {"Ref": "PublicNACL"}
			},
		"PublicRouteTable": {
			"Value": {"Ref": "PublicRouteTable"},
			"Description": "Route table ID for Public Subnets."
			}	

	}
}
  

  STACK
}
