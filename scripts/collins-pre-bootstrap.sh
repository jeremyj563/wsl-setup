#!/bin/bash

rm -rf /etc/resolv.conf || true

echo '# ANSIBLE MANAGED FILE - wsl-setup

nameserver 10.198.0.199
nameserver 10.199.0.199
search rockwellcollins.com mshome.net
' >/etc/resolv.conf

echo '# ANSIBLE MANAGED FILE - wsl-setup

[user]
default = wsl

[network]
generateResolvConf = false

[automount]
options = "metadata"
' >/etc/wsl.conf

echo '# ANSIBLE MANAGED FILE - wsl-setup

Acquire::http::Proxy "http://proxy.rockwellcollins.com:9090";
' >/etc/apt/apt.conf.d/05proxy
