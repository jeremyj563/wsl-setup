#!/bin/bash

yes | sudo apt-add-repository ppa:ansible/ansible

sudo apt update
sudo apt full-upgrade -y

sudo apt install ansible -y
