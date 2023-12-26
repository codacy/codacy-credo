One `Enum.filter/2` is more efficient than `Enum.filter/2 |> Enum.reject/2`.

This should be refactored:

    ["a", "b", "c"]
    |> Enum.filter(&String.contains?(&1, "x"))
    |> Enum.reject(&String.contains?(&1, "a"))

to look like this:

    Enum.filter(["a", "b", "c"], fn letter ->
      String.contains?(letter, "x") && !String.contains?(letter, "a")
    end)

The reason for this is performance, because the two calls to
`Enum.reject/2` and `Enum.filter/2` require two iterations whereas
doing the functions in the single `Enum.filter/2` only requires one.
