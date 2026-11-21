variable "student_id" {
  description = "Student-ID brukt i ressursnavn"
  type        = string
}

variable "location" {
  description = "Azure-region for backend-ressursene"
  type        = string
}

variable "pipeline_principal_id" {
  description = "Object ID for GitHub Actions service principal"
  type        = string
}