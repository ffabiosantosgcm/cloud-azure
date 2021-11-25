variable "namerg" {
  type        = string
  default     = "rg-puc-minas"
  description = "Nome do resorce group"
}


variable "location" {
  type        = string
  default     = "eastus" #Valor padrão se não for informado nenhum valor
  description = "Locaização dos recursos do azure padrão -> eastus "
}

#Criando variavel tipo list

variable "tags" {
  type        = map(any)
  description = "Tags nos recursos e servidores do azure"
  default = {
    ambiente    = "Treinamento"
    responsavel = "Fábio Gomes"
  }
}

#Criando variavel tipo list

variable "vnet_enderecos" {
  type        = list(any)
  default     = ["10.200.0.0/16", "10.100.0.0/16"]
  description = "Espaços de endereços"
}

variable "prefix" {
  default = "puc-minas"
  #description = ""
}

