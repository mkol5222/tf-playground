
```bash
cd /workspaces/tf-playground/70-teller

az login

getLatestTellerVersion() {
    LATEST_ARR=($(wget -q -O- https://api.github.com/repos/tellerops/teller/releases 2> /dev/null | awk '/tag_name/ {print $2}' | cut -d '"' -f 2 | cut -d 'v' -f 2))
    for ver in "${LATEST_ARR[@]}"; do
    if [[ ! $ver =~ beta ]] && [[ ! $ver =~ rc ]] && [[ ! $ver =~ alpha ]]; then
        LATEST="$ver"
        break
    fi
    done
    echo -n "$LATEST"
}

VERSION=$(getLatestTellerVersion)
pushd $(mktemp -d)
wget "https://github.com/tellerops/teller/releases/download/v$VERSION/teller_${VERSION}_Linux_x86_64.tar.gz"
tar xzvf teller_${VERSION}_Linux_x86_64.tar.gz
sudo install teller /usr/local/bin/
popd

cd /workspaces/tf-playground/70-teller
teller new
# or

project: 70-teller

cat << EOF | tee .teller.yml
providers:
  azure_keyvault:
    env:
      DB_PASS:
        path: db-pwd
EOF

cat .teller.yml

cd /workspaces/tf-playground/70-teller/tf-keyvault
tf init
tf apply
export KVAULT_NAME=$(tf output -raw keyvault_name)

cd /workspaces/tf-playground/70-teller 

export AZURE_CLI=1
teller env

teller show
teller env
teller sh

teller put DB_PASS=vpn123 --providers azure_keyvault
teller sh


pushd /workspaces/tf-playground/70-teller/tf-keyvault
tf destroy
tf destroy
popd
```