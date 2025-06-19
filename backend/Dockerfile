FROM python:3.12.0-slim

WORKDIR /app

RUN apt-get update && apt-get install -y bash curl && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

COPY . .

RUN poetry install

ENV PYTHONPATH=/app

EXPOSE 8000

RUN chmod u+x ./prestart.sh

CMD ["sh", "-c", "poetry run bash ./prestart.sh && poetry run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"]
