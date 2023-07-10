variable "numbers" {
    type = list(number)
}

output "sum" {
    value = sum(var.numbers)
}

output "max" {
    value = max(var.numbers...)
}