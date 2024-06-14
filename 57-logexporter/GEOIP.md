# Enhance Check Point logs with ASN

Follow `CPMAN_EXPORT.md` first to setup integration of Security Management with Telegraf over TLS channel using JSON format.

```shell
ssh logexporter

# logexporter: receive CP as JSON first 
cat << EOF | tee ~/telegraf-cp-json.conf
[[outputs.file]]
  files = ["stdout"]

[[inputs.socket_listener]]
  service_address = "tcp://:6514"
  tls_cert = "/etc/telegraf/server.crt"
  tls_key  = "/etc/telegraf/server.key"
  tls_allowed_cacerts = ["/etc/telegraf/ca.pem"]
  data_format = "json_v2"

[[inputs.socket_listener.json_v2]]
  [[inputs.socket_listener.json_v2.object]]
      path = "@this"
      tags = ["action"]
      disable_prepend_keys = true
EOF
# logexporter
sudo cp ~/telegraf-cp-json.conf /etc/telegraf/telegraf.conf
sudo systemctl restart telegraf
sudo journalctl --no-pager -f -u telegraf


# CPMAN:
cp_log_export reexport name logexporter --apply-now


# logexporter: expected logs similar to
# Jun 14 12:43:22 logexporter telegraf[813809]: socket_listener,action=Drop,host=logexporter h_version=5,flags=393216,ifdir="inbound",ifname="eth0",logid=0,loguid="0x666c3ae6,0x1a56,0x42010ac,0x31a36340",origin="20.160.25.71",originsicname="CN=demogw,O=cpman2..e4oy3j",sequencenum=1,time="1717787263000",__policy_id_tag="product=VPN-1 & FireWall-1[db_tag={7C06FD9E-5027-E145-8177-5A0FA3813DE4};mgmt=cpman2;date=1717752905;policy_name=Standard]",dst="172.18.0.4",product="VPN-1 & FireWall-1",proto=6,s_port=59698,service=31886,service_id="tcp-high-ports",src="5.188.206.134",layer_uuid_._._match_table="38271c2f-ab44-4e25-9aa4-e219cb6e12cf",layer_name_._._match_table="Network",match_id_._._match_table=1,rule_uid_._._match_table="2b922948-da96-4c9d-a654-063e0183f9ae",rule_name_._._match_table="Cleanup rule",rule_action_._._match_table="Drop",parent_rule_._._match_table=0 1718368999016901138

# src rc="5.188.206.134" sounds interesting info to be enhanced with ASN using local geoip db

# logexporter: getting the database

# CODESPACE
ssh logexporter
# logexporter:
cd; mkdir w; cd w;
git clone https://github.com/mkol5222/telegraf-geoip
# install GO
sudo apt install golang -y
cd ~/w/telegraf-geoip
go build -o geoip cmd/main.go

cat << EOF | tee ~/geoip.conf
[[processors.geoip]]
db_path = "/var/log/GeoLite2-ASN.mmdb"
db_type = "asn"

[[processors.geoip.lookup]]
  field = "src"
  asn = "asn"
  asn_org = "asn_org"
EOF

# fetch geo db
curl -L https://github.com/PrxyHunter/GeoLite2/releases/download/2024.06.13/GeoLite2-ASN.mmdb -o ~/GeoLite2-ASN.mmdb
sudo mv ~/GeoLite2-ASN.mmdb /var/log/

# try it
sudo cp ./geoip /usr/local/bin/
echo 'a src="8.8.8.8"' | geoip --config ~/geoip.conf
echo 'a src="1.1.1.1"' | geoip --config ~/geoip.conf
echo 'a src="194.228.2.1"' | geoip --config ~/geoip.conf
# 195.113.144.201 tik.cesnet.cz
echo 'a src="195.113.144.201"' | geoip --config ~/geoip.conf


# now we can plug it as processor for telegraf
sudo cp ~/geoip.conf /etc/

cat << EOF | tee ~/telegraf-cp-json-geoip.conf
[[outputs.file]]
  files = ["stdout"]

[[inputs.socket_listener]]
  service_address = "tcp://:6514"
  tls_cert = "/etc/telegraf/server.crt"
  tls_key  = "/etc/telegraf/server.key"
  tls_allowed_cacerts = ["/etc/telegraf/ca.pem"]
  data_format = "json_v2"

[[inputs.socket_listener.json_v2]]
  [[inputs.socket_listener.json_v2.object]]
      path = "@this"
      tags = ["action"]
      
      disable_prepend_keys = true

[[processors.execd]]
command = ["geoip", "--config", "/etc/geoip.conf"]
EOF

sudo cp ~/telegraf-cp-json-geoip.conf /etc/telegraf/telegraf.conf
sudo systemctl restart telegraf
sudo journalctl --no-pager -f -u telegraf


# CPMAN:
cp_log_export reexport name logexporter --apply-now

# expected result = asn and asn_org are added to logs 
#   asn=396982i,asn_org="GOOGLE-CLOUD-PLATFORM"

# Jun 14 13:04:27 logexporter telegraf[890462]: socket_listener,action=Drop,host=logexporter h_version=5,flags=393216,ifdir="inbound",ifname="eth0",logid=0,loguid="0x666c3fd6,0x2d60,0x42010ac,0x20164026",origin="20.160.25.71",originsicname="CN=demogw,O=cpman2..e4oy3j",sequencenum=1,time="1717788730000",__policy_id_tag="product=VPN-1 & FireWall-1[db_tag={7C06FD9E-5027-E145-8177-5A0FA3813DE4};mgmt=cpman2;date=1717752905;policy_name=Standard]",dst="172.18.0.4",product="VPN-1 & FireWall-1",proto=6,s_port=55119,service=9714,service_id="tcp-high-ports",src="35.203.211.254",layer_uuid_._._match_table="38271c2f-ab44-4e25-9aa4-e219cb6e12cf",layer_name_._._match_table="Network",match_id_._._match_table=1,rule_uid_._._match_table="2b922948-da96-4c9d-a654-063e0183f9ae",rule_name_._._match_table="Cleanup rule",rule_action_._._match_table="Drop",parent_rule_._._match_table=0,asn=396982i,asn_org="GOOGLE-CLOUD-PLATFORM" 1718370264518941873



# little cleanup

# logexporter:
cat << EOF | tee ~/telegraf-cp-json-geoip2.conf
[[outputs.file]]
  files = ["stdout"]

[[inputs.socket_listener]]
  service_address = "tcp://:6514"
  tls_cert = "/etc/telegraf/server.crt"
  tls_key  = "/etc/telegraf/server.key"
  tls_allowed_cacerts = ["/etc/telegraf/ca.pem"]
  data_format = "json_v2"
  

[[inputs.socket_listener.json_v2]]
  [[inputs.socket_listener.json_v2.object]]
      path = "@this"
      tags = ["action", "proto", "service"] 
      included_keys = ["src","time"]
      disable_prepend_keys = true

# [[processors.converter]]
#   [processors.converter.tags]
#     timestamp_format  = ["time"]
#     timestamp_format = "unix_ms"

[[processors.execd]]
command = ["geoip", "--config", "/etc/geoip.conf"]
EOF


sudo cp ~/telegraf-cp-json-geoip2.conf /etc/telegraf/telegraf.conf
sudo systemctl restart telegraf
sudo journalctl --no-pager -f -u telegraf

# CPMAN:
cp_log_export reexport name logexporter --apply-now

# expected output
# Jun 14 14:16:12 logexporter telegraf[1144583]: socket_listener,action=Drop,host=logexporter,proto=6,service=9714 time="1717788730000",src="35.203.211.254",asn=396982i,asn_org="GOOGLE-CLOUD-PLATFORM" 1718374570328816364

# more - aggregate ASN count per time window
# logexporter:
cat << EOF | tee ~/telegraf-cp-json-geoip3.conf
[[outputs.file]]
  files = ["stdout"]

[[inputs.socket_listener]]
  service_address = "tcp://:6514"
  tls_cert = "/etc/telegraf/server.crt"
  tls_key  = "/etc/telegraf/server.key"
  tls_allowed_cacerts = ["/etc/telegraf/ca.pem"]
  data_format = "json_v2"
  

[[inputs.socket_listener.json_v2]]
  [[inputs.socket_listener.json_v2.object]]
      path = "@this"
      tags = ["action"] 
      included_keys = ["src","time","asn"]
      disable_prepend_keys = true

# [[processors.converter]]
#   [processors.converter.tags]
#     timestamp_format  = ["time"]
#     timestamp_format = "unix_ms"

[[processors.execd]]
command = ["geoip", "--config", "/etc/geoip.conf"]



# add numeric mertic to be counted later
[[processors.starlark]]
  source = '''
def apply(metric):
    metric.fields["ip"] = 1
    return metric
  '''

[[processors.converter]]
  [processors.converter.fields]
   tag = ["asn"]

# count metric ip per period of n seconds
[[aggregators.basicstats]]
  period = "30s"
  drop_original = false
  stats=["count"]

# optional DB output
# [[outputs.sql]]
#   driver = "sqlite"
#   data_source_name = "file:///tmp/a.sqlite"
EOF


sudo cp ~/telegraf-cp-json-geoip3.conf /etc/telegraf/telegraf.conf
sudo systemctl restart telegraf
sudo journalctl --no-pager -f -u telegraf 
sudo journalctl --no-pager -u telegraf --since "1 hour ago" | grep ip_count

# CPMAN:
cp_log_export reexport name logexporter --apply-now


# logexporter
sudo apt install sqlite3 -y
sqlite3 /tmp/a.sqlite .tables
sqlite3 /tmp/a.sqlite .schema
sqlite3 /tmp/a.sqlite 'select * from socket_listener'

```