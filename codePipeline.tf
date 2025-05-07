resource "aws_codepipeline" "static_site_pipeline" {
  name     = "static-site-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.static_site.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_username
        Repo       = var.github_repo
        Branch     = "main"
        OAuthToken = aws_secretsmanager_secret_version.github_token_version.secret_string
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy_to_S3"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        BucketName = aws_s3_bucket.static_site.bucket
        Extract    = "true"
      }
    }
  }
}
