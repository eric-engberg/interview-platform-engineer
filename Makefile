.PHONY: help up down build logs test clean

help:
	@echo "Available commands:"
	@echo "  make up      Start the service (foreground; Ctrl-C to stop)"
	@echo "  make down    Stop the service"
	@echo "  make build   Force a rebuild of the image"
	@echo "  make logs    Tail container logs"
	@echo "  make test    Send a test embed request"
	@echo "  make clean   Stop the service and remove the image"

up:
	docker compose up

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f

test:
	@curl -sX POST http://localhost:8000/embed \
		-H "Content-Type: application/json" \
		-d '{"text": "Hello, world!"}' | head -c 200
	@echo

clean:
	docker compose down --rmi local
