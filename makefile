.ONESHELL:
.SHELL := /usr/bin/bash
-include .mk/local.mk

# ==========================================================
# Project Configuration
# ==========================================================
DOCKER_COMPOSE := $(shell command -v docker-compose 2>/dev/null || echo "docker compose")
DOCKER_COMPOSE_FILE := docker/docker-compose.yml
PROJECT_NAME ?= $(shell basename $$(pwd))
ENV_FILE := .env

BOLD   := $(shell tput bold 2>/dev/null || echo "")
RED    := $(shell tput setaf 1 2>/dev/null || echo "")
GREEN  := $(shell tput setaf 2 2>/dev/null || echo "")
YELLOW := $(shell tput setaf 3 2>/dev/null || echo "")
BLUE   := $(shell tput setaf 4 2>/dev/null || echo "")
RESET  := $(shell tput sgr0 2>/dev/null || echo "")

# ==========================================================
# PHONY Targets
# ==========================================================
.PHONY: help setup run lint format test build package clean up check-env
.DEFAULT_GOAL := help

# ==========================================================
# Generic Commands
# ==========================================================

help: ## Show available commands
	@echo ""
	@echo "$(BOLD)$(BLUE)Available Commands for $(PROJECT_NAME)$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""

setup: ## Install project dependencies
	@echo "$(YELLOW)No setup command defined for this project.$(RESET)"
	@echo "Add language-specific dependency installation here (e.g., npm install, pip install, go mod tidy)."

run: check-env ## Run the project locally
	@echo "$(YELLOW)No run command defined for this project.$(RESET)"

lint: ## Run lint checks
	@echo "$(YELLOW)No lint command defined for this project.$(RESET)"

format: ## Auto-format code
	@echo "$(YELLOW)No format command defined for this project.$(RESET)"

test: ## Run tests
	@echo "$(YELLOW)No test command defined for this project.$(RESET)"

build: ## Build the project (compile, transpile, or prepare runtime assets)
	@echo "$(YELLOW)No build command defined for this project.$(RESET)"
	@echo "Implement your build commands here (e.g., go build, npm run build, python setup.py build)."

package: build ## Package the project for distribution (tarballs, docker images, etc.)
	@echo "$(YELLOW)No package command defined for this project.$(RESET)"
	@echo "Use this target to prepare release artifacts (e.g., zip files, docker build & tag, npm pack)."

clean: ## Remove caches, temporary files, Docker containers, images, and volumes
	@echo "$(RED)WARNING: This will remove all build artifacts, caches, containers, images, and volumes!$(RESET)"
	@echo "This action cannot be undone."
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "$(GREEN)Cleaning local caches and artifacts...$(RESET)"; \
		rm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov coverage dist build node_modules; \
		find . -type d -name "__pycache__" -exec rm -rf {} +; \
		find . -type f -name "*.pyc" -delete; \
		if [ -f "$(DOCKER_COMPOSE_FILE)" ]; then \
			echo "$(GREEN)Stopping and removing Docker containers, volumes, and images...$(RESET)"; \
			$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v --rmi all --remove-orphans; \
			echo "$(GREEN)Pruning unused Docker resources...$(RESET)"; \
			docker system prune -f; \
		else \
			echo "$(YELLOW)No docker-compose.yml found. Skipping Docker cleanup.$(RESET)"; \
		fi; \
		echo "$(GREEN)Cleanup completed successfully!$(RESET)"; \
	else \
		echo "$(YELLOW)Cleanup cancelled.$(RESET)"; \
	fi

up: check-env ## Start project via Docker Compose
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ]; then \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d; \
	else \
		echo "$(RED)No docker-compose.yml found in docker/$(RESET)"; \
	fi

# ==========================================================
# Internal Check
# ==========================================================
check-env:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "$(RED)ERROR:$(RESET) No .env file found."; \
		echo ""; \
		if [ -f ".env.example" ]; then \
			echo "Run the following command to create it:"; \
			echo "    cp .env.example .env"; \
		else \
			echo "A .env.example file is missing, but you can still create a .env file manually:"; \
			echo "    cp /dev/null .env"; \
		fi; \
		echo ""; \
		echo "After creating the .env file, update the values inside it before continuing."; \
		exit 1; \
	fi
