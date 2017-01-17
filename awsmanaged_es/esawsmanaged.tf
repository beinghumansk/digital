provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_elasticsearch_domain" "es" {
    domain_name = "beinghumansk"
    elasticsearch_version = "2.3"

    advanced_options {
        "rest.action.multi.allow_explicit_index" = "true"
    }
    
    
    cluster_config {
	instance_type = "t2.micro.elasticsearch"
        instance_count = 3
    }
    ebs_options {
        ebs_enabled = "true"
	volume_type = "gp2"
	volume_size = 10
    }
    snapshot_options {
        automated_snapshot_start_hour = 01 
    }

    access_policies = <<CONFIG
    {
 	 "Version": "2012-10-17",
  	"Statement": [
    		{
      		"Sid": "",
      		"Effect": "Allow",
      		"Principal": {
        	"AWS": "*"
     		 },
       "Action": "es:*",
       "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "143.252.80.100"
          ]
         }
        },
       "Resource": "arn:aws:es:eu-west-1:516946924233:domain/beinghumansk/*"
               }
  	]  
   } 	
    
    CONFIG


    tags {
      Domain = "beinghumansk"
    }
}
