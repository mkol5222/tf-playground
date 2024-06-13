// management station IP
data "http" "myip" {
  url = "http://ip.iol.cz/ip/"
}

locals {
  myip = data.http.myip.response_body
}

output "myip" {
  value = data.http.myip.response_body
}