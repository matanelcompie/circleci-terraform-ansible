# circleci-terraform-ansible
## circleci
### Terraform dependencies
1. Add aws credentials for as Context (Organization Settings >> Create Context >> Add Environment Variables)
```
AWS_ACCESS_KEY_ID = ""
AWS_SECRET_ACCESS_KEY = ""
```

### Ansible dependencies
1. Add to project's Environment Variables host name and user name.
```
SSH_HOST = "instance_public_ip"
SSH_USER = "ubuntu"
```
2. Add private key of the public instance to project's SSH Keys. (need also add instance public ip as hostname) 

### circleci api


## Terraform
1. After creating resources go secret manager get ssh key and connect to public instance.
2. Copy key to ~/.ssh/private_key for connecting private instance. (very important otherwise ansible would not be able to connect)

## Ansible (configure private instance)
1. Generate ssh key with ssh-keygen for github.
2. Add public key to github.
3. Add/Create ~/.ssh/config hostkey
```bash
Host github.com
    IdentityFile ~/.ssh/private_key
