data "http" "nfv_virtual_server_ip" {
  depends_on = [null_resource.check_nfv_reachable]
  url = format("%s/%s", var.f5xc_api_url, local.nfv_svc_get_uri)

  request_headers = {
    Content-Type = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}

data "aws_instance" "nfv" {
  depends_on = [null_resource.check_nfv_reachable]

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_tgw_name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [var.f5xc_nfv_node_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["bigip"]
  }
}

data "aws_network_interface" "nfv_external_interface" {
  depends_on = [null_resource.check_nfv_reachable]

  filter {
    name = "tag:Name"
    values = ["BIGIP-External-Private-Interface-0"]
  }

  /*filter {
    name   = "subnet-id"
    values = [var.nfv_subnet_external]
  }*/

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_tgw_name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [var.f5xc_nfv_node_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["bigip"]
  }
}

data "aws_network_interface" "nfv_internal_interface" {
  depends_on = [null_resource.check_nfv_reachable]

  /*filter {
    name   = "subnet-id"
    values = [var.nfv_subnet_internal]
  }*/

  filter {
    name = "tag:Name"
    values = ["BIGIP-Internal-Interface-0"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_tgw_name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [var.f5xc_nfv_node_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["bigip"]
  }
}