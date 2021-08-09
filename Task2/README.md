# Task 2

## Configure SSH connectivity between instances using SSH keys

Generate private SSH key-pair if it doesn't exist yet.
```
ssh-keygen
```

Add pulic key to authorized keys `~/.ssh/authorized_keys` of other server.

Connect to the server, e.g:
```
ssh ubuntu@172.31.45.226 # private ip
ssh ubuntu@18.184.14.247 # public ip
```

## Install web server (Ubuntu)

```
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
echo "<p>Hello World</p>" | sudo tee -a /var/www/html/index.html
echo "<pre>" | sudo tee -a /var/www/html/index.html
cat /etc/os-release | sudo tee -a /var/www/html/index.html
echo "</pre>" | sudo tee -a /var/www/html/index.html
sudo service nginx start
```
Enable HTTP/HTTPS ports at "Security->Security Groups"

## Check HTTP server connectivity
```
curl 18.184.14.247
curl ec2-18-184-14-247.eu-central-1.compute.amazonaws.com
```
 