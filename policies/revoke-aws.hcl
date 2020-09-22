path "sys/leases/revoke/aws/creds/*" {
  capabilities = [ "create", "update", "delete" ]
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