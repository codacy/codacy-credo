Using `Kernel.raise` inside of a `rescue` block creates a new stacktrace.

Most of the time, this is not what you want to do since it obscures the cause of the original error.

Example:

    # preferred

    try do
      raise "oops"
    rescue
      error ->
        Logger.warn("An exception has occurred")

        reraise error, System.stacktrace
    end

    # NOT preferred

    try do
      raise "oops"
    rescue
      error ->
        Logger.warn("An exception has occurred")

        raise error
    end
