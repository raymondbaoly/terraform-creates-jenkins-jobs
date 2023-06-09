provider "jenkins" {}

terraform {
  required_providers {
    jenkins = {
      source = "taiidani/jenkins"
      version = "0.9.3"
    }
  }
}

variable "branch" {
  type        = string
  default     = "main"
  # default     = "building"
}

variable "disabled" {
  type        = string
  default     = "false"
}

locals {
  services = [
    "https://github.com/raymondbaoly/jenkins-webhook-example.git",
    "https://github.com/raymondbaoly/jenkins-example.git"
  ]
}

resource "jenkins_job" "services" {

  count = length(local.services)

  name = replace(basename(local.services[count.index]), ".git", "")

  template = templatefile("${path.module}/job.xml", {
    repo = local.services[count.index]
    branch = var.branch
    disabled = var.disabled
  })
}