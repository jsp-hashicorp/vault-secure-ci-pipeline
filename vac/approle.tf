
# Enable Approle : Mount the AppRole Backend
# $ vault auth enable approle
data "vault_auth_backend" "approle" {
  path = "approle"  
}

# Manages an AppRole auth backend role in a Vault server. 
/*
$ vault write auth/approle/role/aws-read \
    policies="aws" \
    secret_id_num_uses=1 \
    secret_id_ttl="600" \
    token_num_uses=3 \
    token_ttl="600" \
    token_max_ttl="1200"
*/
resource "vault_approle_auth_backend_role" "aws-read" {
 backend = data.vault_auth_backend.approle.path
 role_name = "aws-read"
 secret_id_num_uses = 1
 secret_id_ttl = "600"
 token_ttl ="600"
 token_max_ttl = "1200"
 token_policies = ["default", "aws"]
 token_num_uses = 3
}

// $ vault read -format=json /auth/approle/role/aws-read/role-id | jq -r '.data.role_id'
data "vault_approle_auth_backend_role_id" "role" {
    backend   = data.vault_auth_backend.approle.path
    role_name = vault_approle_auth_backend_role.aws-read.role_name
}

output "role-id" {
  value = data.vault_approle_auth_backend_role_id.role.role_id
}

