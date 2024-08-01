# git-cache-server

A lightweight container that caches git repos and services them with git and http protocol.

1. Use a YAML file to configure git repos
2. Servces git:// protocol with git-daemon.
3. Servces http:// protocol with nginx.
4. Webhook for triggering git fetches.

## Getting Started

```console
make build

make up

# config.yaml listed git-cache-server to cache
git clone http://localhost:8080/git/git-cache-server
```
