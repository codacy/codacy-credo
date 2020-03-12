Either use parentheses or not when defining a function with no arguments.

By default, this check enforces no parentheses, so zero-arity function
and macro definitions should look like this:

def summer? do
  # ...
end

If the `:parens` option is set to `true` for this check, then the check
enforces zero-arity function and macro definitions to have parens:

def summer?() do
  # ...
end

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
