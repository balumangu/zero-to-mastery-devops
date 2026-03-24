# Force zip recreation
data "archive_file" "app" {
  type        = "zip"
  source_dir  = abspath("${path.module}/../../app")
  output_path = "${path.module}/app.zip"
}

# Force upload every time
resource "null_resource" "force_zip" {
  triggers = {
    always_run = timestamp()
  }
}

resource "aws_s3_object" "upload" {
  # Point directly to the variable instead of a local resource ID
  bucket = var.bucket_name
  key    = "artifacts/app.zip"
  source = data.archive_file.app.output_path

  depends_on = [null_resource.force_zip]

  etag = filemd5(data.archive_file.app.output_path)
}