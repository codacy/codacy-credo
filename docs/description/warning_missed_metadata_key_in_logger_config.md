Ensures custom metadata keys are included in logger config

Note that all metadata is optional and may not always be available.

For example, you might wish to include a custom `:error_code` metadata in your logs:

    Logger.error("We have a problem", [error_code: :pc_load_letter])

In your app's logger configuration, you would need to include the `:error_code` key:

    config :logger, :console,
      format: "[$level] $message $metadata\n",
      metadata: [:error_code, :file]

That way your logs might then receive lines like this:

    [error] We have a problem error_code=pc_load_letter file=lib/app.ex
