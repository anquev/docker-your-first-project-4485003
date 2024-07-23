FROM python:3.12-slim-bookworm

RUN useradd -m appuser
WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER appuser
ENV POETRY_HOME="/home/appuser/.local"
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    /home/appuser/.local/bin/poetry --version

ENV PATH="/home/appuser/.local/bin:$PATH"

COPY --chown=appuser:appuser pyproject.toml poetry.lock* ./

RUN poetry install --no-interaction --no-ansi --no-root

COPY --chown=appuser:appuser . .

ENV FLASK_APP=app.py
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
