resource "volterra_http_loadbalancer" "loadbalancer" {
  name                            = var.f5xc_http_loadbalancer_name
  namespace                       = var.f5xc_namespace
  labels                          = var.f5xc_labels
  description                     = var.f5xc_http_loadbalancer_description
  advertise_custom                = var.f5xc_http_loadbalancer_advertise_custom
  advertise_on_public_default_vip = var.f5xc_http_loadbalancer_advertise_on_public_default_vip
  do_not_advertise                = var.f5xc_http_loadbalancer_do_not_advertise
  disable_api_definition          = var.f5xc_http_loadbalancer_disable_api_definition
  disable_ip_reputation           = var.f5xc_http_loadbalancer_disable_ip_reputation
  disable_rate_limit              = var.f5xc_http_loadbalancer_disable_rate_limit
  disable_waf                     = var.f5xc_http_loadbalancer_disable_waf
  disable_bot_defense             = var.f5xc_http_loadbalancer_disable_bot_defense
  service_policies_from_namespace = var.f5xc_http_loadbalancer_service_policies_from_namespace
  no_service_policies             = var.f5xc_http_loadbalancer_no_service_policies
  user_id_client_ip               = var.f5xc_http_loadbalancer_user_id_client_ip
  no_challenge                    = var.f5xc_http_loadbalancer_no_challenge
  domains                         = var.f5xc_http_loadbalancer_domains
  round_robin                     = var.f5xc_http_loadbalancer_round_robin
  least_active                    = var.f5xc_http_loadbalancer_least_active
  random                          = var.f5xc_http_loadbalancer_random
  source_ip_stickiness            = var.f5xc_http_loadbalancer_source_ip_stickiness
  cookie_stickiness               = var.f5xc_http_loadbalancer_cookie_stickiness
  ring_hash                       = var.f5xc_http_loadbalancer_ring_hash
  add_location                    = var.f5xc_http_loadbalancer_add_location

  dynamic "advertise_on_public" {
    for_each = var.f5xc_http_loadbalancer_advertise_on_public_public_ip_name != "" && var.f5xc_http_loadbalancer_advertise_on_public_default_vip == false
    content {
      public_ip {
        tenant    = var.f5xc_tenant
        namespace = var.f5xc_namespace
        name      = var.f5xc_http_loadbalancer_advertise_on_public_public_ip_name
      }
    }
  }

  dynamic "advertise_custom" {
    for_each = var.f5xc_http_loadbalancer_advertise_on_public_default_vip == false ? var.f5xc_http_loadbalancer_advertise_custom : []
    content {

    }
  }

  dynamic "api_rate_limit" {
    for_each = var.f5xc_http_loadbalancer_disable_rate_limit == false
    content {
      no_ip_allowed_list = var.f5xc_http_loadbalancer_api_rate_limit_no_ip_allowed_list
      dynamic "server_url_rules" {
        for_each = var.f5xc_http_loadbalancer_rate_limit_server_url_rules
        content {
          any_domain          = server_url_rules.value.any_domain
          specific_domain     = server_url_rules.value.specific_domain
          base_path           = server_url_rules.value.base_path
          inline_rate_limiter = {
            threshold           = server_url_rules.value.inline_rate_limiter.threshold
            unit                = server_url_rules.value.inline_rate_limiter.unit
            use_http_lb_user_id = server_url_rules.value.inline_rate_limiter.use_http_lb_user_id
          }
        }
      }
    }
  }

  dynamic "http" {
    for_each = var.f5xc_loadbalancer_type == var.f5xc_loadbalancer_type_http ? [1] : []
    content {
      dns_volterra_managed = var.f5xc_http_loadbalancer_type_http_dns_volterra_managed
      port                 = var.f5xc_http_loadbalancer_type_http_port
    }
  }

  dynamic "https" {
    for_each = var.f5xc_loadbalancer_type == var.f5xc_loadbalancer_type_https ? [1] : []
    content {
      http_redirect         = var.f5xc_http_loadbalancer_type_https_http_redirect
      add_hsts              = var.f5xc_http_loadbalancer_type_https_add_hsts
      port                  = var.f5xc_http_loadbalancer_type_https_port
      tls_parameters        = null
      default_header        = {}
      enable_path_normalize = {}
    }
  }

  dynamic "https_auto_cert" {
    for_each = var.f5xc_loadbalancer_type == var.f5xc_loadbalancer_type_custom_https_auto_cert ? [1] : []
    content {
      http_redirect = var.f5xc_http_loadbalancer_type_https_auto_cert_http_redirect
      add_hsts      = var.f5xc_http_loadbalancer_type_https_auto_cert_add_hsts
      port          = var.f5xc_http_loadbalancer_type_https_auto_cert_http_port
      tls_config    = {
        default_security = var.f5xc_http_loadbalancer_type_https_auto_cert_tls_config_high_security
        medium_security  = var.f5xc_http_loadbalancer_type_https_auto_cert_tls_config_medium_security
        low_security     = var.f5xc_http_loadbalancer_type_https_auto_cert_tls_config_low_security
        low_security     = var.f5xc_http_loadbalancer_type_https_auto_cert_tls_config_low_security
      }
      no_mtls               = var.f5xc_http_loadbalancer_type_https_auto_cert_no_mtls
      default_header        = var.f5xc_http_loadbalancer_type_https_auto_cert_default_header
      enable_path_normalize = var.f5xc_http_loadbalancer_type_https_auto_cert_enable_path_normalize
    }
  }

  dynamic "default_route_pools" {
    for_each = var.f5xc_http_loadbalancer_default_route_pools
    content {
      pool {
        tenant    = default_route_pools.value.tenant
        namespace = default_route_pools.value.namespace
        name      = default_route_pools.value.name
      }
      weight           = default_route_pools.value.weight
      priority         = default_route_pools.value.priority
      endpoint_subsets = default_route_pools.value.endpoint_subsets
    }
  }

  dynamic "bot_defense" {
    for_each = var.f5xc_http_loadbalancer_disable_bot_defense == false ? var.f5xc_http_loadbalancer_bot_defense : []
    content {
      regional_endpoint = bot_defense.value.regional_endpoint
      policy {
        protected_app_endpoints {
          metadata {
            name        = bot_defense.value.policy.protected_app_endpoints.metadata.name
            description = bot_defense.value.policy.protected_app_endpoints.metadata.description
            disable     = bot_defense.value.policy.protected_app_endpoints.metadata.disable
          }
          http_methods = bot_defense.value.policy.protected_app_endpoints.http_methods
          protocol     = bot_defense.value.policy.protected_app_endpoints.path.protocol
          any_domain   = bot_defense.value.policy.protected_app_endpoints.path.any_domain
          path {
            prefix = bot_defense.value.policy.protected_app_endpoints.path.prefix
          }
          web    = bot_defense.value.policy.protected_app_endpoints.web
          mobile = bot_defense.value.policy.protected_app_endpoints.mobile
          web_mobile {
            mobile_identifier = "HEADERS"
          }
          mitigation {
            flag {
              no_headers = bot_defense.value.policy.protected_app_endpoints.mitigation.flag.no_headers
            }
            none = bot_defense.value.policy.protected_app_endpoints.mitigation.none
            block {
              body      = bot_defense.value.policy.protected_app_endpoints.mitigation.block.body
              status    = bot_defense.value.policy.protected_app_endpoints.mitigation.block.status
              body_hash = bot_defense.value.policy.protected_app_endpoints.mitigation.block.body_hash
            }
          }
        }
        js_insert_all_pages {
          javascript_location = bot_defense.value.policy.js_insert_all_pages
        }
        js_download_path   = bot_defense.value.policy.js_download_path
        disable_mobile_sdk = bot_defense.value.policy.disable_mobile_sdk
      }
      timeout = bot_defense.value.timeout
    }
  }
}