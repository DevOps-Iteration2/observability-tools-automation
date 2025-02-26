variable "tools" {
  default = {
    prometheus = {
      instance_type = "t3.small"
    }
  }
}

variable "zone_id" {
  default = "Z09871307W8RRL5S85YD"
}