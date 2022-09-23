variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_key" {
  type    = string
  default = ""
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_api_credentials_name" {
  type = string
}

variable "f5xc_api_credential_password" {
  type    = string
  default = ""
}

variable "f5xc_api_credential_expiry_days" {
  type    = number
  default = 0
}

variable "f5xc_api_credential_type_kube_config" {
  type    = string
  default = "KUBE_CONFIG"
}

variable "f5xc_api_credential_type_api_certificate" {
  type    = string
  default = "API_CERTIFICATE"
}

variable "f5xc_api_credential_type" {
  type    = string
  default = "KUBE_CONFIG"

  validation {
    condition     = contains(["KUBE_CONFIG", "API_CERTIFICATE", "API_TOKEN"], var.f5xc_api_credential_type)
    error_message = format("Valid values for f5xc_api_credential_type: API_CERTIFICATE, API_TOKEN, KUBE_CONFIG")
  }
}

variable "f5xc_virtual_k8s_namespace" {
  type    = string
  default = ""
}

variable "f5xc_virtual_k8s_name" {
  type    = string
  default = ""
}