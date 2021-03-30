variable "EcsClusterARN" {
    type = string
}
variable "AlbARN" {
    type = string
}
variable "TgARN" {
    type = string
}
variable "TaskRole" {
    type = string
}
variable "TaskExecRole" {
    type = string
} 
variable "TaskSg" {
    type = string
}
variable "private_subnets" {
    type = list
}