
# Navnet på prosjektet
variable "project" {
  description = "Navn på prosjektet"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,29}$", var.project))
    error_message = "Prosjektnavnet må være 3-30 tegn og bruke små bokstaver, tall eller bindestrek. Det må begynne med en bokstav."
  }
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

# Hvilket nettverk som kan bruke SSH
variable "ssh_source_prefix" {
  description = "Tillatt kilde for SSH"
  type        = string
  default     = "10.0.0.0/16"
}
