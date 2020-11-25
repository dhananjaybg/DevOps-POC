#!/bin/bash -   
# https://www.mongodb.com/blog/post/manage-atlas-database-secrets-hashicorp-vault

export VAULT_ADDR='http://127.0.0.1:8200'


# activate the API secrets
vault secrets enable mongodbatlas

# Authentiate to Atlas using the Master API Keys
vault write mongodbatlas/config \
  public_key="hucaecjq" \
  private_key="73ad2035-da5f-4799-a7fe-3896f01772bc"

# instanciate the role for programatic API Keys @Org level
vault write mongodbatlas/roles/cvs-members \
  organization_id="5dd28f459ccf64a539ae0817" \
  roles="ORG_MEMBER" \
  ip_addresses="98.110.167.37" \
  ttl="2h" \
  max_ttl="48h"

# get new API creds/keys
vault read mongodbatlas/creds/cvs-members


# instanciate the role for programatic API Keys @Project level
vault write mongodbatlas/roles/cvs-owners \
  project_id="5dd28f459ccf64a539ae0817" \
  roles="GROUP_OWNER" \
  ip_addresses="98.110.167.37" \
  ttl="2h" \
  max_ttl="48h"

