# Auto Containerisation GitHub Action

This is a custom composite GitHub Action that uses the newly released [GitHub Models CLI extension (`gh-models`)](https://github.com/github/gh-models) to automatically analyze your project files and generate a Dockerfile containerization recipe. 

The generated recipe is then securely saved into the `$GITHUB_ENV` environment variables, as well as set as a step output, making it extremely easy to reference in subsequent workflow steps or even pass to entirely different jobs.

## Usage

You can use this action in any of your existing GitHub workflows. Just reference it by its path.

```yaml
name: Generate Dockerfile

on:
  push:
    branches:
      - main

jobs:
  containerize:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Generate Container Recipe
        uses: ./ # Assuming the action is in the same repository root. Or user/repo@v1
        id: docker_recipe
        with:
          # Required for GitHub Models to work
          github_token: ${{ secrets.GITHUB_TOKEN }}
          
          # Optional Configuration
          model: 'gpt-4o'
          base_image: 'node:20-alpine'
          ports: '3000'
          package_manager: 'pnpm'
          additional_instructions: 'Install libvips and build-base before dependencies.'

      - name: Use the generated recipe from Environment Variable
        run: |
          echo "The generated Dockerfile is:"
          echo "$CONTAINER_RECIPE"
          
          # You could save it to a file
          echo "$CONTAINER_RECIPE" > Dockerfile

      - name: Use the generated recipe from Step Outputs
        run: |
          echo "The recipe is also available via outputs:"
          echo "${{ steps.docker_recipe.outputs.recipe }}"
```

## Inputs

| Name | Description | Default | Required |
| --- | --- | --- | --- |
| `model` | The GitHub model ID to use (e.g. `gpt-4o`, `meta-llama-3-8b-instruct`) | `gpt-4o` | false |
| `github_token` | GitHub Token for gh CLI authentication | `${{ github.token }}` | true |
| `base_image` | Optional preferred base image (e.g., `python:3.11-slim`, `ubuntu:22.04`) | `""` | false |
| `ports` | Optional comma-separated ports to expose (e.g., `80, 443`) | `""` | false |
| `package_manager` | Optional package manager to use (e.g., `npm`, `yarn`, `poetry`) | `""` | false |
| `additional_instructions` | Any extra instructions for the LLM to follow | `""` | false |
| `prompt` | The base core instructions sent to the model | (Provided internal default) | false |

## Outputs

| Name | Description |
| --- | --- |
| `recipe` | The raw contents of the generated Dockerfile |

## Environment Variables

This action automatically populates the `CONTAINER_RECIPE` environment variable for all subsequent steps within the same job.
