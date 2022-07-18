# WSL Setup
Ansible config for setting up an Ubuntu dev environment in WSL

## Quick Start
Just run these commands locally on a fresh Ubuntu installation
```sh
$ git clone https://github.com/jeremyj563/wsl-setup.git

# First set your linux user in playbook-setup.yaml (optionally configure vars/workspace.yml)

# Then run this script to install ansible and the playbook's requirements:
$ bash bootstrap.sh

# Finally, run the playbook:
$ ansible-playbook --ask-become-pass playbook-wsl-setup.yml
```