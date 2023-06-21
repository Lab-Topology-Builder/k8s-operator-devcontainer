# Contribution Guidelines

Help us improve the devcontainer and documentation of it by sending a pull request. We will review your changes and merge them into the repository if they are approved.

## How to contribute

1. Fork the repository
2. Create a branch with your changes
3. Commit your changes
4. Push your changes to your fork
5. Create a pull request

## How to test your changes

- Run `make bootstrap-buildx` to install buildx
- Run `make build-local` to build the devcontainer locally and output the image as directory
- Run `make build-push` to build the devcontainer locally and push it to the registry (requires docker login)

## How to use the devcontainer

- Install the [VS Code Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
- Open a repository which uses the devcontainer in VS Code
- Use the command `Remote-Containers: Reopen in Container` to reopen the repository in the devcontainer
- Wait for the devcontainer to build and then you can use it
