`Enum.map_join/3` is more efficient than `Enum.map/2 |> Enum.join/2`.

This should be refactored:

    ["a", "b", "c"]
    |> Enum.map(&String.upcase/1)
    |> Enum.join(", ")

to look like this:

    Enum.map_join(["a", "b", "c"], ", ", &String.upcase/1)

The reason for this is performance, because the two separate calls
to `Enum.map/2` and `Enum.join/2` require two iterations whereas
`Enum.map_join/3` performs the same work in one pass.
