# Box configuration

Ansible setup for workstation or server.
Freely inspired by [dschier-wtd/fedora-workstation](https://github.com/dschier-wtd/fedora-workstation).

## Usage

The playbook is designed to be used on a localhost via `ansible-playbook`.

### Requirements

* a RH-based workstation or server / a Debian-based workstation or server
* Ansible
* Python 3 psutil package

#### Ansible & Python 3 psutil

RH-based:
```shell
$ sudo dnf install ansible python3-psutil -y
```

Debian-based:
```shell
$ sudo apt update && sudo apt install ansible python3-psutil -y
```

#### Roles and Collections

Before running the actual playboook, it is needed to install required roles
and collections. This can be done in two simple commands:

```shell
# Install collections
$ ansible-galaxy collection install -r ansible/requirements.yml

# Install roles
$ ansible-galaxy role install -r ansible/requirements.yml
```

### Run a Playbook

#### Tuning variables

You can find a [manifest.yml](./ansible/manifest.yml) in the repository. There
you will find multiple options to configure your desired setup. For now, this
is quite minimal, but you can also check out the `defaults/main.yml` of each
role and change the variables via the `manifest.yml`.

```yaml
---
# ansible/manifest.yml

# System Settings

system:
  hostname: "box.local"
  timezone: "Europe/Paris"

# Enable/Disable Feature Management and Settings
...SNIP...
```

#### The first run

Now you are ready to execute the playbook. Be aware, that this will run for
quite some time, remove packages, download packages and configure a couple of
services.

Workstation:
```shell
# Check run and show diffs
$ ansible-playbook --check --diff -K ansible/playbooks/configure-workstation.yml

# Execute the playbook
$ ansible-playbook -K ansible/playbooks/configure-workstation.yml
```

Server:
```shell
# Check run and show diffs
$ ansible-playbook --check --diff -K ansible/playbooks/configure-server.yml

# Execute the playbook
$ ansible-playbook -K ansible/playbooks/configure-server.yml
```

> *-K* switch can be omitted if running as root

It is a good idea to restart your machine afterwards to ensure that everything
is working and configured as expected.