`Enum.count/2` is more efficient than `Enum.filter/2 |> Enum.count/1`.

This should be refactored:

    [1, 2, 3, 4, 5]
    |> Enum.filter(fn x -> rem(x, 3) == 0 end)
    |> Enum.count()

to look like this:

    Enum.count([1, 2, 3, 4, 5], fn x -> rem(x, 3) == 0 end)

The reason for this is performance, because the two separate calls
to `Enum.filter/2` and `Enum.count/1` require two iterations whereas
`Enum.count/2` performs the same work in one pass.
