`with` statements are useful when you need to chain a sequence
of pattern matches, stopping at the first one that fails.

If the match of the last clause in a `with` statement is identical to the expression in the
in its body, the code should be refactored to remove the redundant expression.

This should be refactored:

    with {:ok, map} <- check(input),
         {:ok, result} <- something(map) do
      {:ok, result}
    end

to look like this:

    with {:ok, map} <- check(input) do
      something(map)
    end
