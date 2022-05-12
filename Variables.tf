variable "location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_name" {
  default = "rg-uks-oauth-demo"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default = {
    Application = "Oauth Apim Demo", Environment = "dev", Keep = "Yes"
  }
}

variable "apim_policies_path" {
  type    = string
  default = "./apim_policies/"
}

variable "api-url" {
  type    = string
  default = "https://serverlessohapi.azurewebsites.net/api/"
}

# do not include the 'api:' part
variable "app_reg_app_id_uri" {
  type = string
  default = "2df27e5a-89fa-4ff2-9606-8a13d080b112"
}

## Microsoft Graph, from az ad sp list --display-name "Microsoft Graph" --query '[].{appDisplayName:appDisplayName, appId:appId}'
variable "msgraphid" {
  type = string
  default = "00000003-0000-0000-c000-000000000000"
}

# The following variables must  be set each time
variable "environment" {
}




