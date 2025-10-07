HOME := $(shell echo $$HOME)
HERE := $(shell echo $$PWD)

# Set bash instead of sh for the @if [[ conditions,
# and use the usual safety flags:
SHELL = /bin/bash -Eeu

.DEFAULT_GOAL := help

.PHONY: help
help:    ## A brief listing of all available commands
	@awk '/^[a-zA-Z0-9_-]+:.*##/ { \
		printf "%-25s # %s\n", \
		substr($$1, 1, length($$1)-1), \
		substr($$0, index($$0,"##")+3) \
	}' $(MAKEFILE_LIST)

.env: .env.sample
	@if [ ! -f .env ]; then \
		echo "Creating .env from .env.sample..."; \
		cp .env.sample .env; \
		echo "✓ .env created. Please edit it with your actual values."; \
	else \
		echo ".env already exists, skipping..."; \
	fi

go.mod:
	go mod init metago

.PHONY: sync
sync: go.mod .env   ## Download dependencies
	go mod download
	go mod tidy && go mod vendor
