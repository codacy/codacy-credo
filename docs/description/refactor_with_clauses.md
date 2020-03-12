`with` statements are useful when you need to chain a sequence
of pattern matches, stopping at the first one that fails.

However, there are a few cases where a `with` can be used incorrectly.

## Starting or ending with non-pattern-matching clauses

If the `with` starts or ends with clauses that are not `<-` clauses,
then those clauses should be moved either outside of the `with` (if
they're the first ones) or inside the body of the `with` (if they're the
last ones). For example look at this code:

    with ref = make_ref(),
         {:ok, user} <- User.create(ref),
         Logger.debug("Created user: #{inspect(user)}") do
      user
    end

This `with` should be refactored like this:

    ref = make_ref()

    with {:ok, user} <- User.create(ref) do
      Logger.debug("Created user: #{inspect(user)}")
      user
    end

# Using only one pattern matching clause with `else`

If the `with` has a single pattern matching clause and no `else`
branch, it means that if the clause doesn't match than the whole
`with` will return the value of that clause. However, if that
`with` has also an `else` clause, then you're using `with` exactly
like a `case` and a `case` should be used instead. Take this code:

    with {:ok, user} <- User.create(make_ref()) do
      user
    else
      {:error, :db_down} ->
        raise "DB is down!"

      {:error, reason} ->
        raise "error: #{inspect(reason)}"
    end

It can be rewritten with a clearer use of `case`:

    case User.create(make_ref()) do
      {:ok, user} ->
        user

      {:error, :db_down} ->
        raise "DB is down!"

      {:error, reason} ->
        raise "error: #{inspect(reason)}"
    end

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
