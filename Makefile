SHELL += -eu

AWS_REGION := us-west-1
COREOS_CHANNEL := stable
COREOS_VM_TYPE := hvm

AWS_EC2_KEY_NAME := k8s-testing
DIR_KEY_PAIR := .ec2-key-pair

.terraform: ; terraform get

_generated.tf:
	./scripts/generate-variables.sh \
		${AWS_REGION} ${COREOS_CHANNEL} ${COREOS_VM_TYPE} ${AWS_EC2_KEY_NAME} \
		> _generated.tf

all: create-key-pair generate apply ## generate key-pair, variables and then `terraform apply`

apply: plan ## `terraform apply`
	terraform apply

clean: destroy delete-key-pair
	rm _generated.tf ||:
	rm -rf .terraform ||:

destroy: ## `terraform destroy`
	terraform destroy

generate: _generated.tf ## generate variables
	
get: ## `terraform get`
	terraform get

help: ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) \
		| fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

plan: get generate ## terraform plan
	terraform plan -out terraform.tfplan

include makefiles/*.mk

.DEFAULT_GOAL := help
.PHONY: all apply clean destroy generate get help plan
