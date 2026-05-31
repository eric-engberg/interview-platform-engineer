# syntax=docker/dockerfile:1.7

FROM ghcr.io/astral-sh/uv:0.9-python3.14-bookworm-slim AS builder

# Use the system Python in the base image rather than letting uv download
# its own; keeps the .venv portable to the runtime stage.
ENV UV_PYTHON_DOWNLOADS=0
# Required when using cache mounts across filesystems (uv default is hardlink,
# which can fail across mount boundaries).
ENV UV_LINK_MODE=copy

WORKDIR /app

# Install dependencies only (not the project itself). This layer caches
# across changes to main.py because main.py is not an input here.
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable

# Pre-download the sentence-transformers model into a known cache location.
# HF_HOME controls where huggingface_hub stores downloaded models.
ENV HF_HOME=/app/model_cache
RUN /app/.venv/bin/python -c \
    "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"

# ---------- runtime stage ----------
FROM python:3.14-slim AS runtime

# Match the env that loaded the model so HF finds the baked-in copy.
ENV HF_HOME=/app/model_cache
# Refuse network access to HF at runtime - the model is already local.
ENV HF_HUB_OFFLINE=1
# Put the venv's bin on PATH so we can run uvicorn without an absolute path.
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

# Copy only what's needed at runtime: the venv, the baked model, the app.
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/model_cache /app/model_cache
COPY main.py /app/main.py

EXPOSE 8000

# Health check uses Python stdlib so we don't need to install curl.
HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://localhost:8000/health').status == 200 else 1)"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
