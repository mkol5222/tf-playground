module "calc" {
    source = "./calc"
    numbers = [10,20,30]
}

output "max" {
    value = "${module.calc.max} is biggest in the list"
}

output "total" {
    value = "sum of all numbers = ${module.calc.sum}"
}