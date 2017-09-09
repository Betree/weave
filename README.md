# Weave

[![Hex.pm](https://img.shields.io/hexpm/v/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/l/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/dw/weave.svg)](https://hex.pm/packages/weave)
[![Build Status](https://travis-ci.org/GT8Online/weave.svg?branch=master)](https://travis-ci.org/GT8Online/weave)
[![codecov](https://codecov.io/gh/GT8Online/weave/branch/master/graph/badge.svg)](https://codecov.io/gh/GT8Online/weave)

## A JIT configuration loader for Elixir

### About

This library makes it possible to load configuration, especially secrets, from disk (Ala Docker Swarm / Kubernetes) on start-up.

### Installation

```elixir
def deps do
  [{:weave, "~> 3.0.1"}]
end
```

### Configuration

```elixir
config :weave,
  file_directories: ["/path/to/secrets"], # Only needed when using the File loader
  environment_prefix: "MYAPP_",           # Only needed when using the Environment loader
  loaders: [
    Weave.Loaders.File,
    Weave.Loaders.Environment
  ]
```

### :weave Module

In order to transform environment variables, or file contents, to runtime configuration, you must tell `:weave` how to handle those values.

You do this by creating a `:weave` module, such as:

```elixir
defmodule MyApp.Weave do
  use Weave

  weave "some_environment_var_without_the_prefix",
    required: false,                # required: can be omitted and defaults to false
    hander:   {:myapp, :some_key},  # handler: can be a function, list or tuple
    hander:   [{:myapp, :some_key}, {:myapp, :another_key}]
    hander:   fn(value) -> Logger.configure(value) end)
end
```

#### Example

Lets assume:

* We are using the environment and file loaders
* We have the `environment_prefix` configured as `MY_APP_`
* We have an environment variable called `MY_APP_NAME`
* We have a file in configured secrets directory called `db_password`

Before being passed to your handler:

* All file-names and environment variables are lower-cased
* Environment variables have the prefix stripped

```elixir
defmodule MyApp.Weave do
  use Weave

  weave "name",         handler: {:app, :name}
  weave "db_password",  required: true, handler: {:app, :password}

  # Sometimes you need to use the same value twice, so return a list.
  weave "kafka_host", handler: [
    {:kaffe, :consumer},
    {:kaffe, :producer}
  ]
end
```

#### Auto Handler Example

##### Warning: We intially thought this would help you reduce all the boilerplate associated with writing handlers. We're now not sure this is really worth it. Use with caution.

In-order to cut down on the boilerplate, you can use the "handler-free" approach and ensure that the values of your environment variables, or contents of files, contain:

```elixir
{:auto, :app, :name, value}
```

### Loading Configuration

You'll need to add the following to your `configure` function, before you prepare your supervisor:

```elixir
MyApp.Weave.configure()
```

### Logging

Weave **may** log sensitive information at the `debug` level, stick to `info` in production.

#### Running Tests with Docker

```shell
$ make clean deps test
```
