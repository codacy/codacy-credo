OS child processes inherit the environment of their parent process. This
includes sensitive configuration parameters, such as credentials. To
minimize the risk of such values leaking, clear or overwrite them when
spawning executables.

The `System.cmd/2,3` function allows environment variables be cleared by
setting their value to `nil`:

    System.cmd("env", [], env: %{"DB_PASSWORD" => nil})

