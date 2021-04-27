FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

ARG DATABASE_URL
ENV DATABASE_URL ${DATABASE_URL:-postgres://postgres:postgres@db:5432/directory_analyzer_dev}

ENV URL localhost
ENV PORT 4000

EXPOSE 4000

COPY mix.exs .
COPY mix.lock .
RUN mix deps get --all

RUN mkdir assets

COPY assets/package.json assets
COPY assets/package-lock.json assets

CMD cd assets && npm install && cd .. && mix phx.server