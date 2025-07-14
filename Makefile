help:
	@echo ""
	@echo "About:"
	@echo "This Makefile is a utility script for managing this Dockerized application efficiently."
	@echo "Unrelated to GCC or code compilation, it acts similarly to a Bash script by automating"
	@echo "repetitive tasks using shell commands, but leverages the structure and simplicity of make."
	@echo "It provides clear commands for common Docker tasks like building the image, starting and "
	@echo "stopping a container, logging, and accessing a shell inside the container."
	@echo ""

	@echo "Usage:"
	@echo "make start            - start the container"
	@echo "make start-verbose    - start the container with verbose output"
	@echo "make stop             - stop the container"
	@echo "make shell            - open a shell in the container"
	@echo "make build            - build the container image"
	@echo ""

build:
	@COMPOSE_BAKE=true docker compose -f ./Docker/compose.yaml build

stop:
	@docker compose -f ./Docker/compose.yaml down

start:
	@xhost +local:docker; \
	docker compose -f ./Docker/compose.yaml up -d

start-verbose:
	@xhost +local:docker; \
	docker compose -f ./Docker/compose.yaml up

shell:
	@docker exec -it -w /root/Omni3D omni3d /bin/bash