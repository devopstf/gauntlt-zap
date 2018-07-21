.PHONY: help
.DEFAULT_GOAL := help

build: ## Building Gauntlt image from Dockerfile
	@echo "Building docker container..."
	@docker build -t gauntlt .

clean: ## Remove unused containers
	@echo "Removing unused docker containers..."
	@docker system prune

clean-all: ## Remove Gauntlt image
	@echo "Removing gauntlt image..."
	@docker rmi gauntlt

interactive: ## Getting into Gauntlt container
	@docker run --rm -it -v $(pwd):/working --entrypoint /bin/bash gauntlt

path: ## Put Gauntlt into your path
	@echo "Copying scripts to /usr/local/bin"
	@cp ./bin/* /usr/local/bin

get-gruyere: ## Get the image of Gruyere sample web app
	@docker pull karthequian/gruyere:latest

gruyere-start: ## Start Gruyere container
	@docker run --rm -d -p 8008:8008 karthequian/gruyere:latest
	@echo "Gruyere is now serving dairy at localhost:8008..."

gruyere-kill: ## Kill Gruyere container
	@docker kill $$(docker ps -a -q --filter ancestor=karthequian/gruyere:latest --format="{{.ID}}")

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
