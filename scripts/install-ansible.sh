#!/bin/bash

sudo apt update &&
    sudo apt install -y software-properties-common &&
    yes | sudo -E apt-add-repository ppa:ansible/ansible &&
    sudo apt update &&
    sudo apt install -y ansible
