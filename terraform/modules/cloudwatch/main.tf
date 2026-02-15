resource "aws_cloudwatch_log_group" "webapp" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "webapp" {
  name           = "webapp-stream"
  log_group_name = aws_cloudwatch_log_group.webapp.name
}
