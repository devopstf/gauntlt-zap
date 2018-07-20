.PHONY: help
.DEFAULT_GOAL := help

build: ## Building Gauntlt image from Dockerfile
	@echo "Building docker container..."
	@./build-gauntlt.sh

clean: ## Remove unused containers
	@echo "Removing unused docker containers..."
	@./docker-clean.sh

clean-all: ## Remove Gauntlt image
	@echo "Removing gauntlt image..."
	@docker rmi gauntlt

interactive: ## Getting into Gauntlt container
	@docker run --rm -it -v $(pwd):/working --entrypoint /bin/bash gauntlt

install-stub: ## Put Gauntlt into your path
	@echo "installing gauntlt-docker to /usr/local/bin"
	@cp ./bin/gauntlt-docker /usr/local/bin

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
