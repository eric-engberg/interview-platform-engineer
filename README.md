# Embeddings

A FastAPI service that returns vector embeddings for text input, packaged
to run in a single container on a laptop.

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/),
  installed and running.

`make` is on macOS already via the Xcode Command Line Tools. If it
isn't, the first `make` invocation will prompt to install them.

## Run it

```
make up
```

First build takes 3 to 5 minutes (downloads dependencies and bakes the
sentence-transformers model into the image). Subsequent runs start in
seconds. The service is on <http://localhost:8000>.

## Test it

```
make test
```

Or hit it directly with curl:

```
curl -X POST http://localhost:8000/embed \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, world!"}'
```

Interactive API docs are at <http://localhost:8000/docs>.

## All commands

Run `make` on its own to see the list:

| Command       | What it does                          |
|---------------|---------------------------------------|
| `make up`     | Start the service                     |
| `make down`   | Stop the service                      |
| `make build`  | Force a rebuild of the image          |
| `make logs`   | Tail container logs                   |
| `make test`   | Send a test embed request             |
| `make clean`  | Stop the service and remove the image |

## Troubleshooting

**Port 8000 already in use.** Find the process with `lsof -i :8000` and
stop it, or change the host port in `docker-compose.yml`:

```yaml
ports:
  - "8001:8000"
```

**`docker: command not found`.** Docker Desktop isn't installed or isn't
running. Start the Docker Desktop app; the menu bar icon shows status.

**First build is slow.** Expected. Downloads ~500MB of dependencies
(PyTorch CPU wheel, transformers, scipy, etc.) and ~90MB for the model.
Subsequent rebuilds reuse cached layers.
