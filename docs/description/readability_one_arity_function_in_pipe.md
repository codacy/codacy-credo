Use parentheses for one-arity functions when using the pipe operator (|>).

    # not preferred
    some_string |> String.downcase |> String.trim

    # preferred
    some_string |> String.downcase() |> String.trim()

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
