
# Kortnavn eller student-ID som brukes i ressursnavn
variable "student_id" {
  description = "Student-ID eller kortnavn"
  type        = string
}

# Navn på prosjektet
variable "project" {
  description = "Navn på prosjektet"
  type        = string
}

# Azure-regionen
variable "location" {
  description = "Azure-regionen"
  type        = string
}

# Azure subscription-ID
variable "subscription_id" {
  description = "Azure subscription-ID"
  type        = string
}
