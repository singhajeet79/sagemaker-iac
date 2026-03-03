provider "aws" {
  region = var.region
}

# --------------------------
# KMS Key for State Encryption
# --------------------------

resource "aws_kms_key" "tf_state" {
  description             = "KMS key for Terraform remote state encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_policy.json
}

resource "aws_kms_alias" "tf_state_alias" {
  name          = "alias/terraform-state-key"
  target_key_id = aws_kms_key.tf_state.key_id
}

# --------------------------
# S3 Bucket for State
# --------------------------
# checkov:skip=CKV_AWS_18:Access logging not required for internal Terraform state bucket
# checkov:skip=CKV_AWS_144:Cross-region replication intentionally not enabled
# checkov:skip=CKV2_AWS_62:Event notifications not required for Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf_state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "tf_state_lifecycle" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    id     = "retain-previous-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# --------------------------
# DynamoDB Lock Table
# --------------------------

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.tf_state.arn
  }
}

# --------------------------
# Bucket Policy - Enforce TLS & Encryption
# --------------------------

data "aws_iam_policy_document" "tf_state_policy" {

  # Deny non-HTTPS requests
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.tf_state.arn,
      "${aws_s3_bucket.tf_state.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  # Deny unencrypted object uploads
  statement {
    sid    = "DenyUnencryptedObjectUploads"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.tf_state.arn}/*"
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }
}

resource "aws_s3_bucket_policy" "tf_state_policy" {
  bucket = aws_s3_bucket.tf_state.id
  policy = data.aws_iam_policy_document.tf_state_policy.json
}

# --------------------------
# KMS Key Policy
# --------------------------
# checkov:skip=CKV_AWS_356:KMS key policies require "*" resource per AWS design
# checkov:skip=CKV_AWS_109:Root key administration permissions required
# checkov:skip=CKV_AWS_111:Root key write permissions intentionally allowed
data "aws_iam_policy_document" "kms_policy" {

  statement {
    sid = "EnableRootPermissions"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::733703293217:root"]
    }

    actions = [
      "kms:DescribeKey",
      "kms:Create*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    resources = ["*"]
  }
}
