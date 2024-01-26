
# custom terraform state http backend with lock support

```shell
cd /workspaces/tf-playground/33-tf-http-backend/
deno task dev

# init backend
terraform init

# apply changes to state
terraform apply -auto-approve

# stored here
cat server.tfstate

# and again to see updates - serial and timestamp in greeting
terraform apply -auto-approve
cat server.tfstate

```
