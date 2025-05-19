.PHONY: build-image start build clean reset

build-image:
	docker compose build

start: build-image
	docker compose up jekyll-dev

build: build-image
	docker compose run --rm jekyll-build

clean:
	rm -rf _site .jekyll-cache .sass-cache
	docker compose down -v
	docker rmi sebastianczechgithubio-jekyll-dev
	docker rmi sebastianczechgithubio-jekyll-build

reset:
	docker image prune --all --force
	docker system prune --all --force