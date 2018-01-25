TESTS=

dshell:
	@docker-compose run --rm elixir bash

dclean:
	@docker-compose down -v

###

clean:
	@mix clean

init:
	@mix do local.hex --force, local.rebar --force

deps:
	@mix deps.get

compile:
	@mix compile

lint:
	@MIX_ENV=test mix credo --strict

test:
	@MIX_ENV=test mix test $(TESTS)

analyse:
	@mix dialyzer

.PHONY: test deps
