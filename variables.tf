variable "aws-region" {
    type = string
    description = "please use standard notation of region, example us-east-1"
}

variable "aws-credentials-profile" {
    type = string
    description = "specify the credential profile that you would like to use, see ~/.aws/credentials"
}