# CLB 实例
resource "tencentcloud_clb_instance" "open_clb" {
  # 负载均衡实例的网络类型，OPEN：公网，INTERNAL：内网
  network_type = "OPEN"
  # 安全组ID列表（需替换成真实安全组列表）
  security_groups = ["sg-1d007a95"]
  # VPC ID（需替换成真实VPC ID）
  vpc_id = "vpc-nnk6bcjt"
  # 子网 ID（需替换成真实子网ID）
  subnet_id = "subnet-ha2x63qo"
}

# CLB 监听器
resource "tencentcloud_clb_listener" "http_listener" {
  clb_id        = tencentcloud_clb_instance.open_clb.id
  listener_name = "http_listener"
  port          = 80
  protocol      = "HTTP"
}

# CLB 转发规则
resource "tencentcloud_clb_listener_rule" "api_http_rule" {
  clb_id      = tencentcloud_clb_instance.open_clb.id
  listener_id = tencentcloud_clb_listener.http_listener.id
  # 转发规则的域名（需替换成真实的域名）
  domain = "api.cloudapp.com"
  # 转发规则的路径
  url = "/"
}

# CLB 后端服务
resource "tencentcloud_clb_attachment" "api_http_attachment" {
  clb_id      = tencentcloud_clb_instance.open_clb.id
  listener_id = tencentcloud_clb_listener.http_listener.id
  rule_id     = tencentcloud_clb_listener_rule.api_http_rule.id

  targets {
    # CVM 实例ID（需替换成真实的实例ID）
    instance_id = "ins-i07qw1ym"
    port        = 80
  }
}


# CLB 监听器（HTTPS）
resource "tencentcloud_clb_listener" "https_listener" {
  clb_id        = tencentcloud_clb_instance.open_clb.id
  listener_name = "https_listener"
  port          = 443
  protocol      = "HTTPS"

  # 证书类型：UNIDIRECTIONAL单向认证、MUTUAL双向认证
  certificate_ssl_mode = "UNIDIRECTIONAL"
  # 服务端证书 ID（需替换成自己的）
  certificate_id = "Fw3oCVfC"
}

# CLB 转发规则（HTTPS）
resource "tencentcloud_clb_listener_rule" "api_https_rule" {
  clb_id      = tencentcloud_clb_instance.open_clb.id
  listener_id = tencentcloud_clb_listener.https_listener.id
  # 转发规则的域名（需替换成真实的域名）
  domain = "api.cloudapp.com"
  # 转发规则的路径
  url = "/"
}

# CLB 后端服务（HTTPS）
resource "tencentcloud_clb_attachment" "api_https_attachment" {
  clb_id      = tencentcloud_clb_instance.open_clb.id
  listener_id = tencentcloud_clb_listener.https_listener.id
  rule_id     = tencentcloud_clb_listener_rule.api_https_rule.id

  targets {
    # CVM 实例ID（需替换成真实的实例ID）
    instance_id = "ins-i07qw1ym"
    port        = 80
  }
}
