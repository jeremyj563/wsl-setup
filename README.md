# WSL Setup

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
        user: <linux-user>

# 4. Configure resolv.conf settings in vars/resolv.yml
    ---
    resolv_nameservers:
    - <primary-dns>
    - <secondary-dns>
    resolv_search:
    - <search-domain>

# 5. Optionally configure vars/workspace.yml if there are any repos you want to clone
    ---
    workspace_dir: <workspace-dir>
    workspace_repos:
    - name: <repo-name>
        url: <repo-url>

# 6. Finally, run the playbook:
wsl-setup$ ansible-playbook playbook-wsl-setup.yml
```