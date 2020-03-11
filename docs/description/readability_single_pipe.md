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
