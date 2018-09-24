`Enum.into/3` is more efficient than `Enum.map/2 |> Enum.into/2`.

This should be refactored:

    [:apple, :banana, :carrot]
    |> Enum.map(&({&1, to_string(&1)}))
    |> Enum.into(%{})

to look like this:

    Enum.into([:apple, :banana, :carrot], %{}, &({&1, to_string(&1)}))

The reason for this is performance, because the separate calls to
`Enum.map/2` and `Enum.into/2` require two iterations whereas
`Enum.into/3` only requires one.
