DATE    ?= $(shell date +%FT%T%z)
VERSION ?= $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || \
                        cat $(CURDIR)/.version 2> /dev/null || echo v0)
GIT_COMMIT       := $$(git rev-parse HEAD)
GIT_COMMIT_SHORT := $$(git rev-parse --short HEAD)
#GIT_TAG          := $$(git describe)

REPOSITORY ?= panta/webssh2
TAG        ?= $(VERSION)

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

.PHONY: all
all: build push

.PHONY: build
build:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Building $(REPOSITORY):$(VERSION)"
	@docker build --no-cache --build-arg VERSION=$(VERSION) --rm -t $(REPOSITORY):$(VERSION) .
	@docker tag $(REPOSITORY):$(VERSION) $(REPOSITORY):latest

.PHONY: push
push:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Pushing $(REPOSITORY):$(VERSION)"
	@docker push $(REPOSITORY)
	@docker push $(REPOSITORY):$(VERSION)
	@docker push $(REPOSITORY):HEAD
