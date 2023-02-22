.PHONY: init setup start-es stop-es start-log stop-log

init:
	cp docker/server/.env.example docker/server/.env
	cp docker/capture/.env.example docker/capture/.env
	echo "Please update \`docker/server/.env\` and \`docker/capture/.env\` files."

setup: stop-log stop-es
	./setup.sh

start-es:
	cd docker/server && docker-compose up -d

stop-es:
	cd docker/server && docker-compose down

start-log:
	cd docker/capture && docker-compose up -d

stop-log:
	cd docker/capture && docker-compose down

stop: stop-log stop-es