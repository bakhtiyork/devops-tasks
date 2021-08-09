sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
echo "<p>Hello World</p>" | sudo tee -a /var/www/html/index.html
echo "<pre>" | sudo tee -a /var/www/html/index.html
cat /etc/os-release | sudo tee -a /var/www/html/index.html
echo "</pre>" | sudo tee -a /var/www/html/index.html
sudo service nginx start