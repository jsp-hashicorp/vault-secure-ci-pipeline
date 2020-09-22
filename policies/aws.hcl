path "aws/*" {
  capabilities = [ "read" ]
}

path "kv/secret-id-concourse" {
  capabilities = [ "create", "update", "read", "list" ]
}

