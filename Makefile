build:
	docker build -t git-cache-server .

run:
	docker run --rm -p 8080:80 git-cache-server

