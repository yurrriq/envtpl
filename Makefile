.PHONY: clean docker test

SOURCES := $(shell find . -not \( -path vendor -prune \) -name \*.go -print)

bin/envtpl: $(SOURCES)
	go build -ldflags "-X main.AppVersionMetadata=$$(date -u +%s)" \
		-o bin/envtpl \
		./cmd/envtpl/.

build: bin/envtpl

install:
	go install ./cmd/envtpl/.

clean:
	rm -rf bin

image:
	nix build -f . docker

test:
	envtpl --version
