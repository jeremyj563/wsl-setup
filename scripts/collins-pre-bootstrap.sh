# PS > $distroName = '<distro-name>'
# PS > Set-UbuntuConfig -DistroName $distroName -NewDistroOnly
# PS > $scriptPath = wsl -d $distroName -u root -e wslpath $env:USERPROFILE/source/repos.personal/jeremyj563/wsl-setup/scripts/collins-pre-bootstrap.sh
# PS > wsl -d $distroName -u root -e bash $scriptPath
# PS > Set-UbuntuConfig -DistroName $distroName -TargetDomain 'collins.com' -ForceBootstrap

#!/bin/bash

rm -rf /etc/resolv.conf || true

echo '## ANSIBLE MANAGED FILE: wsl-setup
nameserver 10.198.0.199
nameserver 10.199.0.199
search rockwellcollins.com mshome.net' >/etc/resolv.conf

echo '## ANSIBLE MANAGED FILE: wsl-setup
[user]
default = wsl

[network]
generateResolvConf = false

[automount]
options = "metadata"' >/etc/wsl.conf

echo '## BEGIN ANSIBLE MANAGED BLOCK: wsl-setup
Acquire::http::Proxy "http://proxy.rockwellcollins.com:9090";
## END ANSIBLE MANAGED BLOCK: wsl-setup' >/etc/apt/apt.conf.d/05proxy
