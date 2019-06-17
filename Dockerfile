FROM python:3.7 AS base
WORKDIR /app
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
ENV PATH="${PATH}:/root/.poetry/bin"
RUN poetry config settings.virtualenvs.create false
COPY poetry.lock pyproject.toml /app/
RUN poetry install --no-dev

FROM base AS dev
RUN poetry install

FROM base as prod
COPY src src
COPY wsgi.py wsgi.py
CMD uwsgi --ini app.ini
