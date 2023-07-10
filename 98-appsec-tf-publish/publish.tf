


data "http" "login" {
  url    = "https://cloudinfra-gw.portal.checkpoint.com/auth/external"
  method = "POST"
  request_body = jsonencode({
    clientId  = var.appsec-client-id
    accessKey = var.appsec-client-secret
  })
  request_headers = {
    "content-type" = "application/json"
  }
}

locals {
  token = jsondecode(data.http.login.response_body)["data"]["token"]
}

# output "token" {
#   value = local.token
# }

data "http" "publishChanges" {
  depends_on = [data.http.login, inext_kubernetes_profile.appsec-k8s-profile]
  url        = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
  method     = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{ "query": "mutation {\n publishChanges {\n isValid\n errors {\n id type subType name message \n }\n warnings {\n id type subType name message\n }\n }\n }" }
EOT
}

output "publish_response_body" {
  value = jsondecode(data.http.publishChanges.body)
}

# # API key to API requests auth token
# function getToken {
#     RESP=$(curl -s --request POST \
#         --url https://cloudinfra-gw.portal.checkpoint.com/auth/external \
#         --header 'content-type: application/json' \
#         --data "{\"clientId\":\"$1\" ,\"accessKey\":\"$2\" }")
#     TOKEN=$(echo "$RESP" | jq -r '.data.token')
# }


# # save changes to management db
# function publishChanges {
#     read -r -d '' QUERY <<'EOF'
#         mutation {
#         publishChanges {
#             isValid
#             errors {
#                 id type subType name message 
#             }
#             warnings {
#             id type subType name message
#             }
#         }
#         }
# EOF
#     BODY=$(jq -r -n --arg Q "$QUERY" '{query:$Q}')


#     RESP=$(curl -s --request POST \
#         --url https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1 \
#         --header "authorization: Bearer ${TOKEN}" \
#         --header 'content-type: application/json' \
#         --data "$BODY")
#     RES=$(echo "$RESP" | jq -r '.')
#     echo "$RES"
# }