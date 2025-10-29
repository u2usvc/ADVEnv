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

### If using proxmox

1. Download the ISO images first, URIs for ISO images are stored within:

- ADVEnv/packer/win-srv/win2016-core.json
- ADVEnv/packer/win-srv/win2022-core.json
- ADVEnv/packer/win10/win10.json

as an iso_url key value. Make sure to save them under the same name as the remote file to `local-lvm`.

2. Upload the `virtio-win-0.1.229.iso` to `local`
3. Run `cd ADVenv/packer/win-srv/ && genisoimage -f -J -joliet-long -r -allow-lowercase -allow-multidot -o unattend.iso scripts/bios/core/autounattend.xml` (and the same thing for `ADVenv/packer/win10`) and upload the unattend.iso to `local` as `win-srv-unattend.iso` for win-srv images and `win10-unattend.iso` for win10 image
4. Install proxmox plugin `packer plugins install github.com/hashicorp/proxmox`
5. Edit the variables file to include your API token (ensure the correct token privs or just create the root@pam token without priv separation): `cd ADVenv/packer/ && mv example pkrvars.json vars.pkrvars.json && vi vars.pkrvars.json`

## Usage

Build golden images:

```bash
# make sure to remove output-qemu* if using qemu
cd ADVEnv/packer/win-srv/ && rm -rf output-qemu* 2>/dev/null

# make sure to change to -only=qemu if using qemu
packer build -only=proxmox-iso -var-file=../vars.pkrvars.json win2016-core.json
packer build -only=proxmox-iso -var-file=../vars.pkrvars.json win2022-core.json
cd ../win10 && packer build -only=proxmox-iso -var-file=../vars.pkrvars.json win10.json
```

Initialize terraform environment:

```
cd ADVEnv/terraform/libvirt && terraform init -upgrade
```

Prepare ansible environment:

```shell
cd ADVEnv/ansible
python3 -m venv ./
. ./bin/activate
pip install pywinrm
pip install ansible
```

Run the setup script (make sure to remove `terraform.tfstate` and `terraform.tfstate.backup` beforehand, if any):

```
./.setup.sh
```
