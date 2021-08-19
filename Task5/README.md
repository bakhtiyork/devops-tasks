# Task 5: Ansible

## Install Ansible
> 1. Deploy three virtual machines in the Cloud. Install Ansible on one of them (control_plane).

I've deployed 3 Ubuntu instances of type "t2.micro".

Installing ansible on first Ubuntu instance.

```
sudo apt install python3-pip
sudo pip3 install ansible
```

Inventory file (hosts.txt):
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

## Playbook
> My First Playbook: write a playbook for installing Docker on two machines and run it.


```yaml
---
- name: My First Playbook
  hosts: all
  become: yes

  tasks:
  - name: install dependencies
    apt:  name={{ item }} state=latest update_cache=yes
    loop: [ 'apt-transport-https', 'ca-certificates', 'curl', 'software-properties-common']
  
  - name: Add Docker GPG apt Key
    apt_key:
      url: https://download.docker.com/linux/ubuntu/gpg
      state: present
  
  - name: Add Docker Repository
    apt_repository:
      repo: deb https://download.docker.com/linux/ubuntu focal stable
      state: present
  
  - name: Update apt and install docker-ce
    apt: update_cache=yes name=docker-ce state=latest

```

Run it:
```
ansible-playbook playbook.yml
```

Output:
```
PLAY [My First Playbook] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu2]
ok: [ubuntu1]

TASK [install dependencies] ****************************************************
ok: [ubuntu2] => (item=apt-transport-https)
ok: [ubuntu1] => (item=apt-transport-https)
ok: [ubuntu2] => (item=ca-certificates)
ok: [ubuntu1] => (item=ca-certificates)
ok: [ubuntu1] => (item=curl)
ok: [ubuntu2] => (item=curl)
ok: [ubuntu2] => (item=software-properties-common)
ok: [ubuntu1] => (item=software-properties-common)

TASK [Add Docker GPG apt Key] **************************************************
ok: [ubuntu2]
ok: [ubuntu1]

TASK [Add Docker Repository] ***************************************************
ok: [ubuntu2]
ok: [ubuntu1]

TASK [Update apt and install docker-ce] ****************************************
ok: [ubuntu2] => (item=docker-ce)
ok: [ubuntu1] => (item=docker-ce)
ok: [ubuntu2] => (item=docker-ce-cli)
ok: [ubuntu1] => (item=docker-ce-cli)
ok: [ubuntu2] => (item=containerd.io)
ok: [ubuntu1] => (item=containerd.io)

PLAY RECAP *********************************************************************
ubuntu1                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu2                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```