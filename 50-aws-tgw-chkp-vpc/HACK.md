
```shell

# https://stackoverflow.com/questions/59952757/how-to-login-to-aws-console-using-access-key-secret-key-and-session-token

cat << EOF | jq -c | tee /tmp/aws-creds
{
  "sessionId": "${AWS_ACCESS_KEY_ID}",
  "sessionKey": "${AWS_SECRET_ACCESS_KEY}",
  "sessionToken": "${AWS_SESSION_TOKEN}"
}
EOF

cat /tmp/aws-creds | jq -c -r . # | base64 | tr -d '\n'
RES=$(curl -s --get "https://signin.aws.amazon.com/federation" \
   --data-urlencode "Action=getSigninToken" \
   --data-urlencode "Session=$(cat /tmp/aws-creds)")

SIGNIN_TOKEN=$(echo $RES | jq -r .SigninToken)

echo "https://signin.aws.amazon.com/federation?Action=login&Destination=https://console.aws.amazon.com/&SigninToken=${SIGNIN_TOKEN}"

```

```shell
```