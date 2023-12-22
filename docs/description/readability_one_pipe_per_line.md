Don't use multiple pipes (|>) in the same line.
Each function in the pipe should be in it's own line.

    # preferred

    foo
    |> bar()
    |> baz()

    # NOT preferred

    foo |> bar() |> baz()

The code in this example ...

    1 |> Integer.to_string() |> String.to_integer()

... should be refactored to look like this:

    1
    |> Integer.to_string()
    |> String.to_integer()

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
