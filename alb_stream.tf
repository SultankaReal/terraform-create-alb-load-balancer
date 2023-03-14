resource "yandex_alb_target_group" "click-target-group-stream" {
  name      = "my-target-group-for-stream"

  target {
    subnet_id = var.default_subnet_id_a
    ip_address   = "10.128.0.31"
  }

  target {
    subnet_id = var.default_subnet_id_b
    ip_address   = "10.129.0.22"
  }
}

resource "yandex_alb_backend_group" "click-backend-group-stream" {
  name      = "click-backend-group-stream"

  stream_backend {
    name = "click-http-backend-stream"
    weight = 1
    port = 9000
    target_group_ids = ["${yandex_alb_target_group.click-target-group-stream.id}"]

    load_balancing_config {
      panic_threshold = 60
    }    
    healthcheck {
      timeout = "1s"
      interval = "1s"
      healthy_threshold = 1
      unhealthy_threshold = 1
      stream_healthcheck {
      }
    }
  }
}


resource "yandex_alb_load_balancer" "test-balancer-new" {
  name        = "click-load-balancer-stream"

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
    name = "click-stream-listener"

    stream {
        handler {
          backend_group_id = yandex_alb_backend_group.click-backend-group-stream.id
        }
    }
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 9000 ]
    }    
  }
}
