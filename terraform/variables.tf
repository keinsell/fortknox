variable "scaleway_region" {
  type        = string
  description = "Scaleway region"
  default     = "pl-waw"
}

variable "scaleway_zone" {
  type        = string
  description = "Scaleway zone"
  default     = "pl-waw-1"
}

variable "scaleway_project" {
  type        = string
  description = "Scaleway project id"
  default     = "d25f8b4c-71cc-463a-9ec9-b193a5d4c04a"
}

variable "scaleway_access_key" {
  type        = string
  description = "Scaleway access key"
}

variable "scaleway_secret_key" {
  type        = string
  description = "Scaleway secret key"
}
