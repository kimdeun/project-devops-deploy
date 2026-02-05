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
	docker build -t $(FULL_IMAGE_NAME) -t $(IMAGE_NAME):latest .

docker-run:
	docker run --rm -p 8080:8080 -p 9090:9090 \
		-e SPRING_PROFILES_ACTIVE=dev \
		$(IMAGE_NAME):latest

docker-test:
	docker run --rm $(IMAGE_NAME):latest \
		sh -c "java -jar app.jar --spring.profiles.active=test & sleep 10 && \
		java -jar app.jar --spring.profiles.active=test --spring.main.web-application-type=none \
		org.springframework.boot.loader.JarLauncher test || true"

docker-push:
	docker push $(FULL_IMAGE_NAME)
	docker push $(REGISTRY)/$(IMAGE_NAME):latest

docker-login:
	@echo "Please login to your container registry:"
	@echo "For Docker Hub: docker login"
	@echo "For GitHub: docker login ghcr.io"
	@echo "For Yandex: docker login cr.yandex"

.PHONY: build docker-build docker-run docker-test docker-push docker-login
