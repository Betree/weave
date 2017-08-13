clean:
	@docker-compose down -v

deps:
	@docker-compose run --rm elixir deps.get

test:
	@docker-compose run --rm -e MIX_ENV=test elixir test

analyse:
	@docker-compose run --rm elixir dialyzer

.PHONY: test deps
