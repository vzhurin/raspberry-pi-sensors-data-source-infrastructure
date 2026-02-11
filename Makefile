.DEFAULT_GOAL := help
PWD := $(shell pwd)

REMOTE_USER=basil
IMAGE_ANSIBLE=cytopia/ansible:2.13
RUN_ANSIBLE=docker run --rm -it \
	-v $(PWD)/ansible:/data/ansible \
	-v $(PWD)/docker:/data/docker \
	-v $(PWD)/ansible_galaxy:/root/.ansible \
	$(IMAGE_ANSIBLE)
RUN_ANSIBLE_PLAYBOOK=$(RUN_ANSIBLE) ansible-playbook
RUN_ANSIBLE_GALAXY=$(RUN_ANSIBLE) ansible-galaxy

.PHONY: help
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: ansible-playbook-run
ansible-playbook-run: ## Install everything on Raspberry Pi
	@$(RUN_ANSIBLE_PLAYBOOK) -i ansible/inventory.yml --ask-pass --user $(REMOTE_USER) ansible/playbook.yml


.PHONY: ansible-galaxy-install
ansible-galaxy-install: ## Install ansible roles and collections
	@$(RUN_ANSIBLE_GALAXY) install -r ansible/requirements.yml
