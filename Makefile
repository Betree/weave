clean:
	@docker-compose down -v

deps:
	@docker-compose run --rm elixir deps.get

lint:
	@docker-compose run --rm elixir credo --strict

test:
	@docker-compose run --rm -e MIX_ENV=test elixir test

analyse:
	@docker-compose run --rm elixir dialyzer

.PHONY: test deps
