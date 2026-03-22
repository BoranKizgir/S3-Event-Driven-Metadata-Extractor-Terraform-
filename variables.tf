variable "aws_region" {
  default = "eu-west-2"
}

variable "bucket_name" {
  description = "benzersiz bir bucket ismi girilecek"
  default = "ybs-cloud-project-storage"
}

variable "table_name" {
  default = "ImageMetaData"
}

