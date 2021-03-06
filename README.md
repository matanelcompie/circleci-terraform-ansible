# circleci-terraform-ansible
## Introduction
This project run ci/cd pipeline with circleci api and will do the following things.
- Create resources in aws via terraform (for now not include in pipeline and run locally)
- Use ansible to checkout branches from (github/bitbucket) on private instance.  

## 01. circleci
### 01.01 Terraform dependencies
1. Add aws credentials for as Context (Organization Settings >> Create Context >> Add Environment Variables)
```
AWS_ACCESS_KEY_ID = ""
AWS_SECRET_ACCESS_KEY = ""
```

### 01.02 Ansible dependencies
1. Add to project's Environment Variables host name and user name.
```
SSH_HOST = "instance_public_ip"
SSH_USER = "ubuntu"
```
2. Add private key of the public instance to project's SSH Keys. (need also add instance public ip as hostname) 

### 01.03 circleci api

1. Create TokenUser at Settings >> Personal API Tokens 
2. export to ~/.bashrc
```
export CIRCLECI_TOKEN="your_token"
```
3. Check api
- project-slug = {project_type}/{org_name}/{repo_name}
- How to use (this will return all pipleline in the project)
```bash
curl --header "Circle-Token: $CIRCLECI_TOKEN" \
  --header 'Accept: text/plain'    \
  https://circleci.com/api/v2/project/{project-slug}/pipeline
```
- Example-01
```bash
 curl -X POST https://circleci.com/api/v2/project/github/matanelcompie/circleci-if-else/pipeline \
 --header 'Content-Type: application/json' \
 --header 'Accept: application/json' \
 --header "Circle-Token: $CIRCLE_TOKEN" \
 -d '{ "branch": "branch_2",    "parameters": {
     "image-tag": "4.8.2"
   } }' | jq '.'
```
this will trigger branch_2 and will run .circleci/config.yml in circleci-if-else project
also we send parameters to config.yml.

## 02. Terraform
1. After creating resources go secret manager get ssh key and connect to public instance.
2. Copy key to ~/.ssh/private_key for connecting private instance. (very important otherwise ansible would not be able to connect)

## 03. Ansible (configure private instance)
1. Generate ssh key with ssh-keygen for github.
2. Add public key to github.
3. Add/Create ~/.ssh/config hostkey
```bash
Host github.com
    IdentityFile ~/.ssh/private_key
