## Install Ansible

```bash
cd /workspaces/tf-playground/80-ansible-cp

./install-ansible.sh
```

## Environment variables

TF_VAR_CPSERVER
TF_VAR_CPID
TF_VAR_CPKEY

or

TF_VAR_MGMTHOST
TF_VAR_MGMTUSER
TF_VAR_MGMTPASS

## Verify login
```bash
curl "https://$TF_VAR_CPSERVER/$TF_VAR_CPID/web_api/login" -d "{\"api-key\":\"$TF_VAR_CPKEY\"}" -H 'Content-Type: application/json' -v

# or
curl "https://$TF_VAR_MGMTHOST/web_api/login" -d "{\"user\":\"$TF_VAR_MGMTUSER\",\"password\":\"$TF_VAR_MGMTPASS\"}" -H 'Content-Type: application/json' -v -k
```

## Running playbook

```bash
cd /workspaces/tf-playground/80-ansible-cp

 ansible-playbook -i ./hosts.ini policy.yml
```

Inventory is supported in multiple formats.
This is how to convert INI to YAML

```bash
cd /workspaces/tf-playground/80-ansible-cp

 ansible-inventory -i hosts.ini -y --list
```


