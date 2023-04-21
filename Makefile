# Build MultiArch Docker images locally for amd64 and arm64 using Docker Buildx to test the Dockerfile
bootstrap-buildx:
	docker context create multiarch
	docker buildx create --name multiarchbuilder --use --bootstrap

build-local:
	docker buildx build --platform linux/amd64,linux/arm64 -t k8s-operator-devcontainer:latest . -o type=local,dest=out --progress=plain

build-push:
	docker buildx build --platform linux/amd64,linux/arm64 -t k8s-operator-devcontainer:latest . --push --progress=plain
