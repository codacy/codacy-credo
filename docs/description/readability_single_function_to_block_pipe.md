A single pipe (`|>`) should not be used to pipe into blocks.

The code in this example ...

    list
    |> length()
    |> case do
      0 -> :none
      1 -> :one
      _ -> :many
    end

... should be refactored to look like this:

    case length(list) do
      0 -> :none
      1 -> :one
      _ -> :many
    end

If you want to disallow piping into blocks altogether, use
`Credo.Check.Readability.BlockPipe`.

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
