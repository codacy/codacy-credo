One `Enum.map/2` is more efficient than `Enum.map/2 |> Enum.map/2`.

This should be refactored:

    [:a, :b, :c]
    |> Enum.map(&inspect/1)
    |> Enum.map(&String.upcase/1)

to look like this:

    Enum.map([:a, :b, :c], fn letter ->
      letter
      |> inspect()
      |> String.upcase()
    end)

The reason for this is performance, because the two separate calls
to `Enum.map/2` require two iterations whereas doing the functions
in the single `Enum.map/2` only requires one.
