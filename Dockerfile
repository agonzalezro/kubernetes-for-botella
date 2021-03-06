FROM elixir:1.4

WORKDIR /app
ADD . /app

RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force

RUN mix compile
CMD ["mix", "bot.run"]
