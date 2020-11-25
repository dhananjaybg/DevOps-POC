#!/bin/bash - 
# https://www.mongodb.com/blog/post/manage-atlas-database-secrets-hashicorp-vault  

export VAULT_ADDR='http://127.0.0.1:8200'

vault secrets enable database

vault write database/config/acme-mongodbatlas-database \
  plugin_name=mongodbatlas-database-plugin \
  allowed_roles="cvs-read-role, cvs-dba-role" \
  public_key="hucaecjq" \
  private_key="73ad2035-da5f-4799-a7fe-3896f01772bc" \
  project_id="5fa3747c38be0136f54f955f"

 vault write database/roles/cvs-read-role \
  db_name=acme-mongodbatlas-database \
  creation_statements='{ "database_name": "admin", "roles": [{"databaseName":"cvshealth","roleName":"read"}]}' \
  default_ttl="1h" \
  max_ttl="24h"
  
vault read database/creds/cvs-read-role


vault write database/roles/cvs-dba-role \
  db_name=acme-mongodbatlas-database \
  creation_statements='{"database_name": "admin", "roles":[{"databaseName":"cvshealth","roleName":"dbAdmin"}]}' \
  default_ttl="1h" \
  max_ttl="24h"



vault read database/creds/cvs-dba-role