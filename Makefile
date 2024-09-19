.ONESHELL:
.SILENT:
.SHELLFLAGS := -c
.DEFAULT_GOAL =


VENV := .venv
PROJECT_NAME := $(notdir $(CURDIR))
PACKAGE_NAME := $(subst -,_,$(PROJECT_NAME))
GIT_TAG := $(shell git describe --tags --abbrev=0)
CURRENT_BRANCH := $(shell git branch --show-current)
CLEANED_TAG := $(subst v,,$(GIT_TAG))

CLEAN_DIRS = build dist



ifeq ($(OS),Windows_NT)
	SHELL = cmd

.PHONY: clean
clean:
	if exist $(PACKAGE_NAME).egg-info rd /s /q $(PACKAGE_NAME).egg-info
	for %%i in ($(CLEAN_DIRS)) do ( if exist %%i rd /s /q %%i )

else
.PHONY: clean
clean:
	rm -rf $(PACKAGE_NAME).egg-info
	for dir in $(CLEAN_DIRS); do \
		rm -rf $$dir; \
	done

endif




.PHONY: info latest_tag
info:
	@echo "project name is: $(PROJECT_NAME)"
	@echo "package name is: $(PACKAGE_NAME)"


latest_tag:
	@echo "Latest Git tag (cleaned): $(CLEANED_TAG)"

