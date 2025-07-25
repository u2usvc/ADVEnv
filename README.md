## About
In-development Active Directory IaC lab environment indended as a basis for utility testing. This project is heavily influenced by `Orange-Cyberdefense/GOAD`, however, unlike GOAD, this project is built only for libvirt/QEMU, utilizing `microsoft.ad` a more up-to-date ansible module, and overall has some major structural differences AD-wise.

Planned integrations:
- Wazuh
- Suricata
- KES
- ADCS
- SCCM
- ADFS

## Prerequisites
1. terraform, libvirt and qemu should be installed.
2. `libvirtd` should be running.
3. ensure your user is a member of `libvirt` group

## Usage
Build golden images:
```bash
cd ./packer/win2022/ && rm -rf output-qemu* && packer build win2022-core.json
packer build win2016-core.json
cd ./packer/win10/ && rm -rf output-qemu/ && packer build win10.json
```

Initialize terraform environment:
```
cd ./terraform/ && terraform init -upgrade
```

Prepare ansible environment:
```shell
cd ansible
python -m venv ./
. ./bin/activate
pip install pywinrm
pip install ansible
```

Run the setup script (make sure to remove `terraform.tfstate` and `terraform.tfstate.backup` beforehand, if any):
```
./.setup.sh
```
