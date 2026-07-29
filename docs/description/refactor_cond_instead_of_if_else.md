Prefer `cond` over `if/else` blocks.

So while this is fine:

    if allowed? do
      :ok
    end

The use of `else` could impact readability:

    if allowed? do
      :ok
    else
      :error
    end

and could be improved to:

    cond do
      allowed? -> :ok
      true -> :error
    end

There's no technical reason for this; it's a matter of preferred code style.

NOTE: This check is mutually exclusive with `Credo.Check.Refactor.CondStatements`,
which recommends the opposite. Enable only one of these checks.
