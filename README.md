# git-cache-server

A lightweight container that caches git repos and services them with git and http protocol.

1. Use a YAML file to configure git repos
2. Servces git:// protocol with git-daemon.
3. Servces http:// protocol with nginx.
4. Webhook for triggering git fetches.

## Getting Started

```console
docker build -t git-cache-server .

docker run --rm -p 8080:80 git-cache-server

docker exec git-http-server bash -c "mkdir -p /srv/git/my-repo && cd /srv/git/my-repo && git init --bare"

git clone http://localhost:8080/my-repo
```
