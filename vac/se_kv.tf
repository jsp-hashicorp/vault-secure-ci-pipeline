# Enable K/V v2 secrets engine at 'kv-v2'
resource "vault_mount" "kv" {
  path = "kv"
  type = "kv-v2"
}