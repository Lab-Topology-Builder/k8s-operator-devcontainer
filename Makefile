# Build MultiArch Docker images locally for amd64 and arm64 using Docker Buildx to test the Dockerfile
local-create:
	docker context create multiarch
	docker buildx create --name multiarchbuilder --use --bootstrap

local-build:
	docker buildx build --platform linux/amd64,linux/arm64 -t k8s-operator-devcontainer:latest . -o type=oci,dest=out --progress=plain
