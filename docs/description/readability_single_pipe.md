Pipes (`|>`) should only be used when piping data through multiple calls.

So while this is fine:

    list
    |> Enum.take(5)
    |> Enum.shuffle
    |> evaluate()

The code in this example ...

    list
    |> evaluate()

... should be refactored to look like this:

    evaluate(list)

Using a single |> to invoke functions makes the code harder to read. Instead,
write a function call when a pipeline is only one function long.

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
