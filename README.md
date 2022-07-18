# WSL Setup

- [WSL Setup](#wsl-setup)
  - [Synopsis](#synopsis)
  - [Quick Start](#quick-start)

## Synopsis
Ansible config for setting up an Ubuntu dev environment in WSL

## Quick Start
Perform the following steps locally on a fresh Ubuntu installation:
```sh
# 1. Clone this repo into your source code workspace folder
$ git clone https://github.com/jeremyj563/wsl-setup.git ./wsl-setup && cd $_

# 2. Run the bootstrap script to install ansible and the playbook's requirements:
wsl-setup$ bash bootstrap.sh

# 3. Set your linux user in playbook-wsl-setup.yml
    ---
    - hosts: localhost
    vars:
        user: <linux-username>

# 4. Optionally configure vars/workspace.yml if there are any repos you want to clone
    ---
    workspace_dir: ~/source/repos
    workspace_repos:
    - name: <repo-name>
        url: <repo-url>

# 5. Finally, run the playbook:
wsl-setup$ ansible-playbook --ask-become-pass playbook-wsl-setup.yml
```