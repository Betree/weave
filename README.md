# Weave

**Note:** The canonical repository is hosted [here](https://gitlab.com/gt8/open-source/elixir/weave), on GitLab.com.

[![Hex.pm](https://img.shields.io/hexpm/v/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/l/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/dw/weave.svg)](https://hex.pm/packages/weave)
[![build status](https://gitlab.com/gt8/open-source/elixir/weave/badges/master/pipeline.svg)](https://gitlab.com/gt8/open-source/elixir/weave/commits/master)
[![code coverage](https://gitlab.com/gt8/open-source/elixir/weave/badges/master/coverage.svg)](https://gitlab.com/gt8/open-source/elixir/weave/commits/master)


## A JIT configuration loader for Elixir

### About

This library makes it possible to load configuration, especially secrets, from disk (Ala Docker Swarm / Kubernetes) on start-up.

#### Icon

“To Weave” icon by Amrit Mazumder from the Noun Project.

### Installation

```elixir
def deps do
  [{:weave, "~> 3.1"}]
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

### Weave Module

In order to transform environment variables, or file contents, to runtime configuration, you must tell Weave how to handle those values.

You do this by creating a Weave module, such as:

```elixir
defmodule MyApp.Weave do
  use Weave

  weave "some_environment_var_without_the_prefix",
    required: false,                # required: can be omitted and defaults to false
    handler:   {:myapp, :some_key},  # handler: can be a function, list or tuple
    handler:   [{:myapp, :some_key}, {:myapp, :another_key}]
    handler:   fn(value) -> Logger.configure(value) end)
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
