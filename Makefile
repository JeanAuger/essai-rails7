.POSIX:
.SUFFIXES:
.PHONY: help
.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_.-]+$?{?.*+}?:.*?##/ \
		{printf "\033[36m%-27s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


### DOCKER
DK_IMG_NAME = devrb-baseline
DK_PORT = 3003
dk-img: ## Builds the regular docker image
	docker build . -t ${DK_IMG_NAME}
dk-run: ## Runs a docker container
	@echo Run the following:
	@echo "docker run -it --rm -v ${PWD}:/app -p ${DK_PORT}:3000 ${DK_IMG_NAME}"
