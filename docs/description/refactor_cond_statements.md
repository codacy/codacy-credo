Each cond statement should have 3 or more statements including the
"always true" statement.

Consider an `if`/`else` construct if there is only one condition and the
"always true" statement, since it will more accessible to programmers
new to the codebase (and possibly new to Elixir).

Example:

    cond do
      x == y -> 0
      true -> 1
    end

    # should be written as

    if x == y do
      0
    else
      1
    end

