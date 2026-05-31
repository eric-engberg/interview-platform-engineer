# Design notes

Decisions made for this submission and the reasoning behind them.

## Dockerfile

- **Multi-stage build**, builder + runtime. The builder installs
  dependencies and downloads the model; the runtime image holds only
  the `.venv`, the baked model, and `main.py`.

- **CPU-only PyTorch** via `[tool.uv.sources]` in `pyproject.toml`,
  pinning torch to the PyTorch CPU index. This required adding torch
  as a direct dependency since uv only honors `[tool.uv.sources]` for
  direct deps. Without this, the default torch wheel on linux/amd64
  pulls in the full NVIDIA CUDA library tree (~3GB of GPU libraries)
  that the service never uses.

- Baked the model into the image rather than mounting it from a volume.
  Keeps everything in one artifact - no separate volume to manage.
  Also makes the image portable between machines without a re-download
  if that's ever useful.

- **uv image as the builder base**
  (`ghcr.io/astral-sh/uv:0.9-python3.14-bookworm-slim`). uv is already
  the project's package manager; using the Astral-published image
  keeps the toolchain consistent and avoids an install layer.

- **BuildKit cache mounts** for uv's package cache. Keeps the cache
  out of the image layers (image stays small) and makes rebuilds fast
  when dependencies change incrementally - uv only re-downloads the
  changed package, not the whole tree.

- **Healthcheck** uses Python's stdlib `urllib` so the runtime image
  doesn't need `curl` installed. Uses the `/health` endpoint.

## Service definition

- **docker-compose, not Helm.** Considering the requirements Helm
  is overly complex.  A very simple docker compose is sufficient.

- **Resource limits** (`deploy.resources.limits`) cap the container
  at 2 CPUs and 2GB RAM. The user runs this on a laptop
  alongside other applications. Without limits the app could starve
  other processes of resources.

- **Log rotation** (`logging.options.max-size`, `max-file`) caps
  total log storage at 30MB (3 files x 10MB). Prevents the container
  from filling disk if the user leaves it running for extended periods
  of time.

## Command runner

- **`make` as the user-facing entry point.**  make is available on
  MacOS without any extra steps.  Using other things like `just`
  could require the user to do extra installs.
