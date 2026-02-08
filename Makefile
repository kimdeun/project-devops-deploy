# Docker image configuration
IMAGE_NAME ?= project-devops-deploy
IMAGE_TAG ?= latest
REGISTRY ?= docker.io
# For GitHub Container Registry use: ghcr.io/your-username
# For Yandex Container Registry use: cr.yandex/your-registry-id
# For Docker Hub use: docker.io/your-username (or just your-username)
FULL_IMAGE_NAME = $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

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
	docker build -t my-app .

docker-run:
	docker run -p 8080:8080 -p 9090:9090 my-app
