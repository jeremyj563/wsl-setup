#!/bin/bash

sudo -E apt update &&
    sudo -E apt install -y software-properties-common &&
    yes | sudo -E apt-add-repository ppa:ansible/ansible &&
    sudo -E apt update &&
    sudo -E apt install -y ansible;
