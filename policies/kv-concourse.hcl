path "kv/+/secret-id-concourse" {
  capabilities = [ "create", "update", "read", "list" ]
}

path "kv/+/aws-keys-concourse" {
  capabilities = [ "create", "update", "read", "list" ]
}
path "auth/token/lookup" {
  capabilities = [ "create", "update", "list", "read" ]
}

path "auth/token/lookup-self" {
  capabilities = [ "create", "update", "list", "read" ]
}

path "auth/token/lookup-accessor" {
  capabilities = [ "create", "update", "list", "read" ]
}