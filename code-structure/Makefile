dev:
	rm -rf ./terraform
	terraform init --backend-config=dev-env/state.tfvars
	terraform apply --auto-approve --var-file=dev-env/input.tfvars
prod:
	rm -rf ./terraform
	terraform init --backend-config=prod-env/state.tfvars
	terraform apply --auto-approve --var-file=prod-env/input.tfvars