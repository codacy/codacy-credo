A function call should not be nested inside another function call.

So while this is fine:

    Enum.shuffle([1,2,3])

The code in this example ...

    Enum.shuffle(Enum.uniq([1,2,3,3]))

... should be refactored to look like this:

    [1,2,3,3]
    |> Enum.uniq()
    |> Enum.shuffle()

Nested function calls make the code harder to read. Instead, break the
function calls out into a pipeline.

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
