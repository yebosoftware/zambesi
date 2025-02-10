# The below has been tested, and works well
# terraform {
#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = "~> 2.0"
#     }
#     supabase = {
#       source  = "supabase/supabase"
#       version = "1.5.1"
#     }
#   }

#   # backend "s3" {
#   #   bucket = "your-space-name"     # DigitalOcean Space name
#   #   region = "nyc3"                # Space region (e.g., nyc3, sfo2)
#   #   key    = "path/to/statefile.tfstate"  # Path within the Space (e.g., `myproject/terraform.tfstate`)
#   #   access_key = "your-access-key"  # DigitalOcean access key
#   #   secret_key = "your-secret-key"  # DigitalOcean secret key
#   #   endpoint = "nyc3.digitaloceanspaces.com"  # Endpoint for DigitalOcean Spaces (nyc3, sfo2, etc.)
#   #   acl = "private"               # Make the state file private
#   # }
# }

# Variables

# Supabase
variable "supabase_access_token" {
  description = "Supabase API key"
  type        = string
  default     = ""
}

variable "supabase_organization_id" {
  description = "Supabase organization id"
  type        = string
  default     = ""
}

variable "supabase_project_region" {
  description = "Supabase project region"
  type        = string
  default     = ""
}

variable "supabase_project_name" {
  description = "Supabase project name"
  type        = string
  default     = ""
}

variable "supabase_database_password" {
  description = "Supabase database password"
  type        = string
  default     = ""
}

variable "supabase_build_dir" {
  description = "Supabase build dir"
  type        = string
  default     = ""
}

# Digital Ocean
variable "digital_ocean_access_token" {
  description = "Digital ocean access token"
  type        = string
  default     = ""
}

variable "digital_ocean_project_name" {
  description = "Digital ocean project name"
  type        = string
  default     = ""
}

variable "digital_ocean_project_description" {
  description = "Digital ocean project description"
  type        = string
  default     = ""
}

variable "netlify_access_token" {
  description = "Netlify access token"
  type        = string
  default     = ""
}

variable "frontend_build_dir" {
  description = ""
  type        = string
  default     = ""
}

# Providers
# provider "digitalocean" {
#   token = var.digital_ocean_access_token
# }

# provider "supabase" {
#   access_token = var.supabase_access_token
# }

# Modules

# Backend module
module "kunene" {
  source = "git::https://github.com/yebosoftware/kunene.git"

  digital_ocean_access_token = var.digital_ocean_access_token
  digital_ocean_project_name = var.digital_ocean_project_name
  digital_ocean_project_description = var.digital_ocean_project_description

  supabase_access_token = var.supabase_access_token
  supabase_database_password = var.supabase_database_password
  supabase_organization_id = var.supabase_organization_id
  supabase_project_name = var.supabase_project_name
  supabase_project_region = var.supabase_project_region
  supabase_build_dir = var.supabase_build_dir
}

# Frontend module
module "nile" {
  source = "git::https://github.com/yebosoftware/nile.git"
  depends_on = [module.kunene]

  netlify_access_token = var.netlify_access_token
  frontend_build_dir = var.frontend_build_dir
  digital_ocean_app_url = module.kunene.digital_ocean_app_url
}