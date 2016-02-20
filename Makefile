SHELL += -eu

AWS_REGION := us-west-1
COREOS_CHANNEL := stable
COREOS_VM_TYPE := hvm

AWS_EC2_KEY_NAME := k8s-testing

DIR_KEY_PAIR := .key-pair
DIR_SSL := .ssl

## generate key-pair, variables and then `terraform apply`
all: create-key-pair create-ssl init apply

## destroy and remove everything
clean: destroy destroy-ssl delete-key-pair
	rm terraform.{tfvars,tfplan} ||:
	rm -rf .terraform ||:

## smoke it
test: test-ssl test-route53 test-etcd

include makefiles/*.mk

.DEFAULT_GOAL := help
.PHONY: all clean test
