terraform {
  backend "s3" {
    bucket = "terraform-statefile-sravan"
    key    = "terraform/mykey"
  }
}