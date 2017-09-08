defmodule MyApp.Weave do
    @moduledoc """
    Example Weave Module
    """
    use Weave

    weave "database_host",      required: true,
        handler: {:example_app, :database_host}

    weave "database_password",  handler: {:example_app, :database_password}
    weave "database_port",      handler: {:example_app, :database_port}
    weave "cookie_secret",      handler: {:example_app, :cookie_secret}
end
