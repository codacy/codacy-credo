One `Enum.reject/2` is more efficient than `Enum.reject/2 |> Enum.reject/2`.

This should be refactored:

    ["a", "b", "c"]
    |> Enum.reject(&String.contains?(&1, "x"))
    |> Enum.reject(&String.contains?(&1, "a"))

to look like this:

    Enum.reject(["a", "b", "c"], fn letter ->
      String.contains?(letter, "x") || String.contains?(letter, "a")
    end)

The reason for this is performance, because the two separate calls
to `Enum.reject/2` require two iterations whereas doing the
functions in the single `Enum.reject/2` only requires one.
