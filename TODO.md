# This is what would be nice to do

[x] Change shell to zsh (probably once moved to ansible)
[x] Move installers to an ansible playbook. This also mean that the first stage of the bootstrapping process will be to install python and ansible and then run the playbook.

[ ] Install tinty theme somewhere
[ ] Do not require sudo password for packages
[ ] GUI apps might only be installed on the first install (after which each desktop lives its life ?)
[ ] Make sure rust nightly is installed via mise (or brew ?)
[ ] Install inside containers should really be smaller. We need to find a way to split up Brew
essentials from niceties
[ ] Brew diff and automatic target assignation could be improved. It is brittle
