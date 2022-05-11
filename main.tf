#Create ALB http-router 
#Link to terraform documentation - https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/alb_http_router

resource "yandex_alb_http_router" "nursultan1994-router" {
  name      = "nursultan1994-http-router"
  labels = { //Labels to assign to this HTTP Router. A list of key/value pairs
    tf-label    = "tf-label-value"
    empty-label = "empty-tf-label-value"
  }
}

#Create ALB
#Link to terraform documentation - https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/alb_load_balancer

resource "yandex_alb_load_balancer" "nursultan1994-balancer" {
  depends_on = [yandex_alb_http_router.nursultan1994-router]
  name        = "nursultan1994-balancer"

  network_id  = var.default_network_id

  allocation_policy {
    location {
      zone_id   = var.default_zone_a
      subnet_id = var.default_subnet_id_zone_a 
    }
  }

  listener {
    name = "nursultan1994-listener"
    endpoint {
      address {
        external_ipv4_address { //Provided by the client or computed automatically (in this case ipv4 address is computed automatically)
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.nursultan1994-router.id
      }
    }
  }    
}