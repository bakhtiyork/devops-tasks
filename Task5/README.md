# Task 5: Ansible

## Install Ansible
> 1. Deploy three virtual machines in the Cloud. Install Ansible on one of them (control_plane).

I've deployed 3 t2.micro Ubuntu instances.

Installing ansible on first Ubuntu instance.

```
sudo apt install python3-pip
sudo pip3 install ansible
```

Inventory file:
```
[servers]
ubuntu1 ansible_host=3.68.224.119
ubuntu2 ansible_host=3.68.113.102

[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/.ssh/default.pem
```

Config file (ansible.cfg):
```
[defaults]
host_key_checking = false
inventory         = ./hosts.txt
```


## Ping Pong
> 2. Ping pong - execute the built-in ansible ping command. Ping the other two machines.

```
ansible all -m ping
```

Output:
```
ubuntu1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
ubuntu2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```