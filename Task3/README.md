# Task 3

## Terraform
It creates: 
* VPC (lines 9-16)
* Subnet (lines 17-22)
* Internet Gateway (lines 24-26)
* Route Table (lines 28-24)
* Security Group for Ubuntu server which allows incoming ICMP, TCP/22, 80, 443, and any outgoing access (lines 44-80)
* Security Group for CentOS server which allows outgoing and incoming access: ICMP, TCP/22, 80, 443 within VPC cidr block (82-139)
* EC2 instance CentOS host (lines 203-209)
* EC2 instance Ubuntu host (lines 149-201), nginx installation and web page creation (lines 159-168), docker installation (lines 172-177)



## Extra

> 6. Complete  step 1, but AMI ID cannot be hardcoded. You can hardcode operation system name, version, etc. 

It can be externalized to variables file or OS enviroment, e.g
```
$ export TF_VAR_UBUNTU_AMI=ami-abc123
```


  

> 7. EC2 CentOS should have outgoing and incoming access: ICMP, TCP/22, 80, 443, only to EC2 Ubuntu

We can specify only Ubuntu host private IP address for Security Group rules:
```
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_instance.ubuntu_server.private_ip]
  }
```

  
  
> 8. On EC2 CentOS install nginx (note. Remember about step 7, the task can be done in any way, it is not necessary to use terraform)
> - Create a web page with the text “Hello World” and information about the current version of the operating system. This page must be visible from the  EC2 Ubuntu.

From Ubuntu host:
* Download nginx rpm
* Copy to CentOS host via SSH
* Install it on CentOS host
* Run nginx

E.g:
```
  provisioner "remote-exec" {
    inline = [
      "curl https://nginx.org/packages/centos/8/x86_64/RPMS/nginx-1.20.1-1.el8.ngx.x86_64.rpm -o nginx.rpm",
      "scp nginx.rpm centos@${aws_instance.centos_server.private_ip}:/home/centos",
      "ssh centos@${aws_instance.centos_server.private_ip} -f 'sudo rpm -i nginx.rpm'",
      "ssh centos@${aws_instance.centos_server.private_ip} -f 'sudo systemctl start nginx'"
    ]
  }

```

