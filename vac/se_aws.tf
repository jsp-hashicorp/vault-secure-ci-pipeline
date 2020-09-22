/*
$ vault secrets enable aws
$ vault write aws/config/root \
    access_key=*** \
    secret_key=*** \
    region=ap-northeast-2
$ vault write aws/config/lease lease=10m lease_max=10m
*/
resource "vault_aws_secret_backend" "aws" {
  # Follwing values need to be redacted :access_key, secret_key
    access_key="***"
    secret_key="***""
  region     = "ap-northeast-2"
  default_lease_ttl_seconds = 600
  max_lease_ttl_seconds = 600
}

/*
$ vault write aws/roles/vlt-ci-role \  
    credential_type=iam_user \
    policy_document=-<<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "rds:*",
                    "ec2:*",
                    "elasticloadbalancing:*"
                ],
                "Resource": "*"
            }
        ]
    }
    EOF
*/
resource "vault_aws_secret_backend_role" "role" {
  backend = vault_aws_secret_backend.aws.path
  name    = "vlt-ci-role"
  credential_type = "iam_user"

  policy_document = <<EOT
{
     "Version": "2012-10-17",
     "Statement": [
         {
             "Sid": "VisualEditor0",
             "Effect": "Allow",
             "Action": [
                 "rds:*",
                 "ec2:*",
                 "elasticloadbalancing:*"
             ],
             "Resource": "*"
         }
     ]
}
EOT
}

# Apply Policy 
/*
$ vault policy write kv-concourse kv-concourse.hcl
*/
resource "vault_policy" "kv-concourse" {
  name = "kv-concourse"

  policy = file("../policies/kv-concourse.hcl")
}

// $ vault policy write pull-secret-id pull-secret-id.hcl
resource "vault_policy" "pull-secret-id" {
  name = "pull-secret-id"

  policy = file("../policies/pull-secret-id.hcl")
}

//$ vault policy write aws aws.hcl
resource "vault_policy" "aws" {
  name = "aws"

  policy = file("../policies/aws.hcl")
}

//$ vault policy write revoke-aws revoke-aws.hcl
resource "vault_policy" "revoke-aws" {
  name = "revoke-aws"

  policy = file("../policies/revoke-aws.hcl")
}


// $ vault token create -policy kv-concourse -no-default-policy
resource "vault_token" "kv-concourse" {
  policies = ["kv-concourse"]
  no_default_policy = true
}

// $ vault token create -policy pull-secret-id -no-default-policy
resource "vault_token" "pull-secret-id" {
  policies = ["pull-secret-id"]
  no_default_policy = true
}

// $ vault token create -policy revoke-aws -no-default-policy
resource "vault_token" "revoke-aws" {
  policies = ["revoke-aws"]
  no_default_policy = true
}

resource "local_file" "ci_var" {
    content     = <<YAML
vault_addr: http://192.168.1.177:8200
vault_kv_token: ${vault_token.kv-concourse.client_token}
vault_init_token: ${vault_token.pull-secret-id.client_token}
vault_revoke_token: ${vault_token.revoke-aws.client_token}
YAML

    filename = "../ci/vars.yml"
}


output "kv-token" {
    value = vault_token.kv-concourse.client_token
}

output "pull-secret-id" {
    value = vault_token.pull-secret-id.client_token
}

output "revoke-aws" {
    value = vault_token.revoke-aws.client_token
}