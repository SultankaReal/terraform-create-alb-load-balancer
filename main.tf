#Link to terraform documentation - https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/alb_load_balancer

resource "yandex_alb_target_group" "click-target-group" {
  name      = "my-target-group"

  target {
    subnet_id = var.default_subnet_id_a
    ip_address   = "10.128.0.31"
  }

  target {
    subnet_id = var.default_subnet_id_b
    ip_address   = "10.129.0.22"
  }
}

resource "yandex_alb_backend_group" "click-backend-group" {
  name      = "click-backend-group"

  http_backend {
    name = "click-http-backend"
    weight = 1
    port = 8123
    target_group_ids = ["${yandex_alb_target_group.click-target-group.id}"]

    load_balancing_config {
      panic_threshold = 60
    }    
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/ping"
      }
    }
    http2 = "false"
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name      = "my-http-router" 
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name      = "my-virtual-host"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "click-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.click-backend-group.id
        timeout = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "click-load-balancer"

  network_id  = var.default_network_id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = var.default_subnet_id_a
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = var.default_subnet_id_b 
    }
  }

  listener {
    name = "click-http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 8123 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }
}
