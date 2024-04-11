.POSIX:
.SUFFIXES:
.PHONY: help
.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_.-]+$?{?.*+}?:.*?##/ \
		{printf "\033[36m%-27s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


### DOCKER
DK_IMG_NAME = devrb-jean
DK_IMG_NAME_BASELINE = ${DK_IMG_NAME}-baseline
DK_PORT = 3000
DK_PORT_BASELINE = 3333
dk-img-baseline: ## Builds the regular docker image
	git checkout master
	git checkout demojean Dockerfile
	docker build . -t ${DK_IMG_NAME_BASELINE}
	git restore --staged Dockerfile && rm Dockerfile
	git checkout demojean
dk-img: ## Builds the regular docker image
	git checkout demojean
	docker build . -t ${DK_IMG_NAME}
dk-run: ## Runs a docker container
	@echo Run either of the following:
	@echo "docker run -it --rm -v ${PWD}:/app -p ${DK_PORT}:3000 ${DK_IMG_NAME}"
	@echo "docker run -it --rm -v ${PWD}:/app -p ${DK_PORT_BASELINE}:3000 ${DK_IMG_NAME_BASELINE}"
