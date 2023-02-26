# Create MultiArch Docker images for amd64 and arm64
local-create:
	docker context create multiarch
	docker buildx create --name multiarchbuilder --use --bootstrap

local-build:
	docker buildx build --platform linux/amd64,linux/arm64 -t k8s-operator-devcontainer:latest .
