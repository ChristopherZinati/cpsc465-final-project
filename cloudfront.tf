resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cf-access"
  description                       = "Access control for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

