provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "esearchvpc" {
    cidr_block = "10.0.0.0/16"

    tags  { 
     Name = "esearchvpc" 
    }
}

resource "aws_subnet" "esubnet1" {
    vpc_id = "${aws_vpc.esearchvpc.id}"
    cidr_block = "10.0.1.0/24"
    tags {
        Name = "esubnet1"
    }
}


resource "aws_security_group" "essg" {
  name = "essg"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.esearchvpc.id}"  

  ingress { 
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["176.250.108.199/32"]
  }
  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["176.250.108.199/32"]
  }

}


resource "aws_internet_gateway" "esearchgw" {
    vpc_id = "${aws_vpc.esearchvpc.id}"

    tags {
        Name = "esearchgw"
    }
}


resource "aws_instance" "esinstance1" {
  ami  =  "ami-b9b394ca" 
  instance_type = "t2.micro"
  key_name = "staginges"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.essg.id}"]
  subnet_id = "${aws_subnet.esubnet1.id}"
  root_block_device {
	volume_type = "gp2"
	volume_size = 10
  }
  tags {
	Name = "esinstance1"
  }
}


resource "aws_instance" "esinstance2" {
  ami  =  "ami-b9b394ca" 
  instance_type = "t2.micro"
  key_name = "staginges"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.essg.id}"]
  subnet_id = "${aws_subnet.esubnet1.id}"
  root_block_device {
	volume_type = "gp2"
	volume_size = 10
  }
  tags {
	Name = "esinstance2"
  }
}


resource "aws_instance" "esinstance3" {
  ami  =  "ami-b9b394ca" 
  instance_type = "t2.micro"
  key_name = "staginges"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.essg.id}"]
  subnet_id = "${aws_subnet.esubnet1.id}"
  root_block_device {
	volume_type = "gp2"
	volume_size = 10
  }
  tags {
	Name = "esinstance3"
  }
}


resource "aws_elb" "elasticsearchelb" {
  name = "es-terraform-elb"
  security_groups = ["${aws_security_group.essg.id}"]
  subnets = ["${aws_subnet.esubnet1.id}"]

  access_logs {
    bucket = "elasticsearch123"
    bucket_prefix = "elb"
    interval = 60
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }

  instances = ["${aws_instance.esinstance1.id}","${aws_instance.esinstance2.id}","${aws_instance.esinstance3.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "es-terraform-elb"
  }
}
