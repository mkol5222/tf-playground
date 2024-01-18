terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "random" {
  # Configuration options
}

resource "random_pet" "pejsek" {
  keepers = {
    name = "ferda2"
  }
  length = 2
}



locals {
  pets = jsondecode(file("pets.json"))
}

resource "random_pet" "pets" {
  for_each = {
    for index, pet in local.pets :
        pet.name => pet
  }
    keepers = {
     name = each.key
  }
  length = each.value.len
}

output "zviratko" {
  value = "${random_pet.pejsek.id} hello"
}

output "pets" {
  value = local.pets
}

output "petslist" {
  value = random_pet.pets
}