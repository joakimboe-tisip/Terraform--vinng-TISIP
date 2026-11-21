
# Navnet på prosjektet
variable "project" {
  description = "Navn på prosjektet"
  type        = string
}

# Azure-regionen
variable "location" {
  description = "Azure-regionen"
  type        = string
}

# Navnet på ressursgruppen
variable "resource_group_name" {
  description = "Navn på ressursgruppen"
  type        = string
}
