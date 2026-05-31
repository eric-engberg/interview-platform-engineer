# Platform Engineer — Take-Home Assignment


You have been given a working FastAPI service called **Embeddings** — a small REST API that accepts text and returns vector embeddings using `sentence-transformers`. Your job is to make this service _"production-ready"_ for a team of **data scientists who run everything on their laptops**.

The assignment has two parts — plan for roughly one hour each. Both are intentionally open-ended; part of what we are evaluating is how you prioritize and decide what to build. You may use any open-source tools or LLM assistance, provided the end result runs locally on macOS with Docker Desktop installed. Include clear instructions for everything you provide and be prepared to walk through your decisions.


## Part 1 — Containerization & Command Runner

Write a `Dockerfile` that correctly packages the Embeddings service using a multi-stage build to keep the final image small
and provide a centralized command runner — `mise`, `just`, `make`, or equivalent — to install dependencies, version tooling, and build the project.

## Part 2 — Service Definitions

Create a service definition for Embeddings — a `docker-compose.yml` or Helm chart — and wire it into the command runner from Part 1

## Bonus — Model Caching

Bake the model weights into the image or cache them efficiently so they are not re-downloaded on every build.

## Deliverables

Fork this repository and open a PR with your changes.

## What We Are Evaluating

- Is it easy to get the project running from a clean checkout?
- Does the service build and run on macOS with Docker Desktop?
- Is your documentation complete and concise, without obvious LLM-generated filler?
- Could a data scientist with no operations experience get this running by following your instructions alone?
- Did you account for the platform-specific requirements of the `sentence-transformers` package?


## Questions

If anything is ambiguous, make a decision, document your reasoning, and move on. We are evaluating how you think, not whether you read our minds.
