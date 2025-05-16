resource "aws_iam_role" "stepfunctions_execution_role" {
  name = "stepfunctions-execution-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "states.eu-north-1.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "stepfunctions_logs" {
  role = aws_iam_role.stepfunctions_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_sfn_state_machine" "pr_env_orchestrator" {
  name = "PR-env-orchestrator-${random_string.suffix.result}"
  role_arn = aws_iam_role.stepfunctions_execution_role.arn

  definition = jsonencode({
    Comment = "State machine for orchestration"
    StartAt = "Start",
    States = {
      Start = {
        Type = "Succeed"
        Comment = "Starting the orchestration process."
      }
    }
  })
}

resource "random_string" "suffix" {
  length = 8
  special = false
  upper = false
  numeric = true
}
