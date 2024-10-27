IMAGE=front-end
DOCKER_IFLAG := $(if $(GITHUB_ACTIONS),"-i","-it")

.PHONY: test coverage


dev: clean test-image server

# Brings the backend services up using Docker Compose
compose:
	@docker compose -f test/docker-compose.yml up -d

# Runs the Node.js application in a Docker container
server:
	@docker run               \
		-d                      \
		--name $(IMAGE)     \
		-v $$PWD:/usr/src/app   \
		-e NODE_ENV=development \
		-e PORT=8080            \
		-p 8080:8080            \
		--network test_default  \
		$(IMAGE) /bin/sh -c "/usr/local/bin/npm install && /usr/local/bin/npm start"

# Removes the development container & image
clean:
	@if [ $$(docker ps -a -q -f name=$(IMAGE) | wc -l) -ge 1 ]; then docker rm -f $(IMAGE); fi
	@if [ $$(docker images -q $(IMAGE) | wc -l) -ge 1 ]; then docker rmi $(IMAGE); fi

# Builds the Docker image used for running tests
test-image:
	@docker build -t $(IMAGE) -f test/Dockerfile .

# Runs unit tests in Docker
test-front-end: test-image
	@docker run              \
    --rm                   \
    $(DOCKER_IFLAG)         \
    -v $$PWD:/usr/src/app   \
    $(IMAGE) /bin/sh -c "/usr/local/bin/npm install && /usr/local/bin/npm test"

build:
	chmod +x scripts/build.sh
	./scripts/build.sh

test-sock-shop: build
	docker compose up -d
	

# Runs integration tests in Docker
e2e: test-image
	@docker run              \
		--rm                   \
		-it                    \
		--network test_default \
		-v $$PWD:/usr/src/app  \
		$(IMAGE) /bin/sh -c "/usr/src/app/test/e2e/runner.sh"

kill-compose:
	@docker compose -f test/docker-compose.yml down

kill-server:
	@if [ $$(docker ps -a -q -f name=$(IMAGE) | wc -l) -ge 1 ]; then docker rm -f $(IMAGE); fi
