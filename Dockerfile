FROM python:3.11-slim as builder

ARG MODE=PROD

# install PDM
RUN pip install -U pip setuptools wheel
RUN pip install pdm
RUN apt-get update && apt-get install -y cmake build-essential libssl-dev

# copy files
COPY pyproject.toml pdm.lock README.md /project/

# install dependencies and project into the local packages directory
WORKDIR /project
RUN mkdir __pypackages__

RUN if [ "$MODE" = "PROD" ] ; then pdm sync --prod --no-editable; else pdm sync --dev --no-editable; fi

FROM python:3.11-slim

# retrieve packages from build stage
ENV PYTHONPATH=/project/pkgs
COPY --from=builder /project/__pypackages__/3.10/lib /project/pkgs
# retrieve executables
COPY --from=builder /project/__pypackages__/3.10/bin/* /bin/

WORKDIR /app


# Application src
COPY src/ src/

# Pyproject
COPY pyproject.toml .

# Entrypoint
ENTRYPOINT [ "uvicorn", "src.main:app", "--host=0.0.0.0", "--port=8000", "--workers=1"]
