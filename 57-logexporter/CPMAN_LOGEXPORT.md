# Connect Check Point Management cp_log_exporter

```shell
# lets start on Check Point Management VM (use your own or create in Azure)
ssh cpman2
# cpman, bash: create csr
mkdir ~/logexporter; cd ~/logexporter
# cpman, bash: private key
openssl genrsa -out cpman.key 2048
# cpman, bash: csr
export CLIENT_IP=$(curl_cli -s ip.iol.cz/ip/)
export PASS=vpn123
openssl req -new -key cpman.key -out cpman.csr -subj "/C=US/ST=TX/L=test/O=TestCert/CN=${CLIENT_IP}" -passin pass:$PASS
```

Will sign on logexporter VM to create `cpman.crt`
```shell
# CODESPACE
ssh logexporter
# logexporter
cd ~/ca
# logexporter (cut and paste cpman.csr contents , Ctrl-D)
cat > cpman.csr
# logexporter
openssl req -text -noout -verify -in cpman.csr | grep CN
# logexporter sign it
openssl x509 -req -in cpman.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out cpman.crt -days 825 -sha256
# check Subject
openssl x509 -in cpman.crt -noout -text | grep CN
# now transfer cpman.crt back to Check Point Management
```

Back at Check Point Management, in bash:
```shell
ssh cpman2
# cpman, bash: create csr
cd ~/logexporter
cat > cpman.crt
openssl x509 -in cpman.crt -text -noout | grep CN
# make it to P12 as expected by cp_log_exporter
export PASS=vpn123
openssl pkcs12 -export -inkey cpman.key -in cpman.crt -out cpman.p12 -passout pass:$PASS
# read back
cpopenssl pkcs12 -in cpman.p12 -info -passin pass:$PASS

# also tranfer ca.pem from logexporter
cd ~/logexporter; cat > ca.pem
openssl x509 -in ca.pem -noout -text | grep CN

# setup new connection
# your logexporter VM address
export SERVERIP=13.94.184.173
export PASS=vpn123
chmod -v +r /home/admin/logexporter/cpman.p12
chmod -v +r /home/admin/logexporter/ca.pem
cp_log_export add name logexporter target-server $SERVERIP target-port 6514 protocol tcp format json encrypted true ca-cert /home/admin/logexporter/ca.pem client-cert /home/admin/logexporter/cpman.p12 client-secret $PASS time-in-milli true --apply-now

cp_log_export status name logexporter

tail -f /opt/CPrt-R81.20/log_exporter/targets/logexporter/log/log_indexer.elg
vi /opt/CPrt-R81.20/log_exporter/targets/logexporter/targetConfiguration.xml
cp_log_export reexport name logexporter --apply-now
tail -f /opt/CPrt-R81.20/log_exporter/targets/logexporter/log/log_indexer.elg
```