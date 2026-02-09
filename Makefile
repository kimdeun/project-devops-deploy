# Docker image configuration
IMAGE_NAME ?= 123c/hexlet
IMAGE_TAG ?= latest
REGISTRY ?= docker.io
GIT_SHA ?= $(shell git rev-parse --short HEAD)
# For GitHub Container Registry use: ghcr.io/your-username
# For Yandex Container Registry use: cr.yandex/your-registry-id
# For Docker Hub use: docker.io/your-username (or just your-username)
FULL_IMAGE_NAME = $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
SHA_IMAGE_NAME = $(REGISTRY)/$(IMAGE_NAME):sha-$(GIT_SHA)

test:
	./gradlew test

start: run

run:
	./gradlew bootRun

update-gradle:
	./gradlew wrapper --gradle-version 9.2.1

update-deps:
	./gradlew refreshVersions

install:
	./gradlew dependencies

build:
	./gradlew build

lint:
	./gradlew spotlessCheck

lint-fix:
	./gradlew spotlessApply

# Docker commands
docker-build:
	docker build -t $(FULL_IMAGE_NAME) -t $(SHA_IMAGE_NAME) .

docker-push:
	docker push $(FULL_IMAGE_NAME)
	docker push $(SHA_IMAGE_NAME)

docker-run:
	docker run -p 8080:8080 -p 9090:9090 my-app
