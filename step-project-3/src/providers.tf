terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }

  # Используем локальный backend для создания бакета (потом можно переключиться на s3)
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  profile = "mfa"
  region  = "eu-central-1"
}

# Создание S3 бакета
resource "aws_s3_bucket" "terraform_state" {
  bucket = "ioann-jenkins-terraform-state"
}

# Настройка политики владения объектами — здесь вы можете использовать нужный режим
resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Установка bucket policy, разрешающей полный доступ владельцу аккаунта
resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowAccountAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::708426825474:root"
        },
        Action   = "s3:*",
        Resource = [
          "${aws_s3_bucket.terraform_state.arn}",
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
      }
    ]
  })
}

# Включение версионирования для бакета
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Настройка серверного шифрования (SSE) с использованием AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

/*
Чтобы переключиться на S3 backend, раскомментируйте блок ниже 
и выполните:
  
  terraform init -reconfigure

backend "s3" {
  bucket  = "ioann-jenkins-terraform-state"
  key     = "/Step3/terraform.tfstate"
  region  = "eu-central-1"
  profile = "mfa"
}
*/