FROM python:3.8-slim

RUN pip install pipenv

RUN mkdir /app
WORKDIR /app

COPY Pipfile Pipfile.lock ./

RUN set -ex && pipenv install --deploy --system

RUN groupadd -r app && useradd -r -g app app
USER app

COPY . .

EXPOSE 5000
ENTRYPOINT ["sh", "./devops/entrypoint.sh"]
