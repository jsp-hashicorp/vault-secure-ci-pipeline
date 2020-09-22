FROM vault:latest
ENV VAULT_TOKEN root
ENV VAULT_ADDR http://48d593ca3a09.ngrok.io
RUN apk update
RUN apk add curl
RUN apk add jq
RUN wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
RUN unzip terraform_*.zip
RUN chmod +x terraform
RUN mv terraform /bin/
RUN VAULT_ADDR=$VAULT_ADDR VAULT_TOKEN=$VAULT_TOKEN vault read -format=json auth/approle/role/aws-read/role-id | jq -r '.data.role_id' > /role-id