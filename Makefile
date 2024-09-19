.ONESHELL:
.DEFAULT_GOAL := help

VENV := .venv
PROJECT_NAME := $(notdir $(CURDIR))
PACKAGE_NAME := $(subst -,_,$(PROJECT_NAME))
GIT_TAG := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
CLEANED_TAG := $(patsubst v%,%,$(GIT_TAG))

CLEAN_DIRS := build dist $(PACKAGE_NAME).egg-info

ifeq ($(OS),Windows_NT)
	SHELL := cmd.exe
	ifneq (,$(findstring powershell,$(SHELL)))
		RM_DIR = if (Test-Path "$1") { Remove-Item "$1" -Recurse -Force }
	else ifneq (,$(findstring pwsh,$(SHELL)))
		RM_DIR = if (Test-Path "$1") { Remove-Item "$1" -Recurse -Force }
	else
		RM_DIR = if exist "$(1)" rd /s /q "$(1)"
	endif
else
	RM_DIR = rm -rf "$1"
endif

.PHONY: clean info latest_tag help

clean:
	@echo "Cleaning directories..."
	$(foreach dir,$(CLEAN_DIRS),\
		$(shell $(call RM_DIR,$(dir))) \
	)
	@echo "Clean completed."

info:
	@echo "You are running on $(OS) with $(SHELL) shell."
	@echo "Project name: $(PROJECT_NAME)"
	@echo "Package name: $(PACKAGE_NAME)"
	@echo "Current branch: $(CURRENT_BRANCH)"
	@echo "Current directory: $(CURDIR)"
	@echo "Git tag: $(GIT_TAG)"

latest_tag:
	@echo "Latest Git tag (cleaned): $(CLEANED_TAG)"

help:
	@echo "Available targets:"
	@echo "  clean       - Remove build artifacts and directories"
	@echo "  info        - Display project information"
	@echo "  latest_tag  - Show the latest Git tag"
	@echo "  help        - Display this help message"
