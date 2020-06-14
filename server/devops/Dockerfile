FROM python:3.8-alpine

RUN pip install pipenv

RUN mkdir /app
WORKDIR /app

COPY Pipfile Pipfile.lock ./

RUN set -ex && pipenv install --deploy --system

RUN addgroup -S app && adduser -S -G app app
USER app

COPY . .

EXPOSE 5000
ENTRYPOINT ["sh", "./devops/entrypoint.sh"]
