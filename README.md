# Box configuration

Ansible setup for workstation or server.
Freely inspired by [dschier-wtd/fedora-workstation](https://github.com/dschier-wtd/fedora-workstation).

## Usage

The playbook is designed to be used on a localhost via `ansible-playbook` for the workstation playbook
or remotely on hosts from an inventory for the server playbook.

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
ansible-galaxy collection install -r ansible/requirements.yml

# Install roles
ansible-galaxy role install -r ansible/requirements.yml
```

### Run a Playbook

#### Workstation
```shell
# Check run and show diffs
ansible-playbook --check --diff -K ansible/playbooks/workstation/configure.yml -e "hosts_group=localhost"

# Execute the playbook
ansible-playbook -K ansible/playbooks/workstation/configure.yml -e "hosts_group=localhost"
```

#### Server

First create your inventory, for instance:

```shell
cat > ./inventory.yml <<EOF
all:
  vars:
    ansible_private_key_file: ~/.ssh/id_ed25519 # the key used to connect to the hosts, not the one to authorize for users
    ansible_user: root                          # the user to connect to the hosts to configure them, not the one used to connect to them
    hostname: "{{ inventory_hostname }}"        # will use the "<hostname>" defined at the "all/children/<group>/hosts/<hostname>" inventory path
    timezone: "Europe/Paris"                    # the timezone for the server

    # Features
    feature_docker: true                        # add Docker packages (users with docker flag will be able to use it)
    feature_ohmyzsh: true                       # install Oh My Zsh
    oh_my_zsh_theme: ys                         # the theme for Oh My Zsh
    users:                                      # users to create (or update) and their configuration
      - username: root
      - username: mathieu
        ssh_authorized_keys: https://github.com/debovema.keys
        sudoernopassword: true
        docker: true
  children:
    scaleway: # a group to categorize your hosts (e.g. the Cloud provider is 'scaleway')
      hosts:
        devno1-3:
          ansible_host: 163.123.45.67
    hetzner: # a group to categorize your hosts (e.g. the Cloud provider is 'hetzner')
      hosts:
        devno1-4:
          ansible_host: 2a01:4ff:123:456::2
          # Hetzner rescue mode installation (optional)
          hetzner_install_disk_by_id_pattern: "*SAMSUNG*"
          hetzner_install_image: Debian-1202-bookworm-amd64-base.tar.gz
          # Features
          feature_wireguard_4in6_tunnel: true # copy wgclient.conf file in ansible/roles/wireguard_4in6_tunnel/files directory
EOF
```

```shell
# Check run and show diffs
ansible-playbook -i inventory.yml --check --diff ansible/playbooks/server/configure.yml

# Execute the playbook
ansible-playbook -i inventory.yml ansible/playbooks/server/configure.yml
```

If using Hetzner hosts with rescue mode enabled, install them automatically with this playbook:

```shell
ansible-playbook -i inventory.yml ansible/playbooks/hetzner/install.yml --limit 'devno1-4'
```