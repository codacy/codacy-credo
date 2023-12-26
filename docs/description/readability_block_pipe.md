Pipes (`|>`) should not be used with blocks.

The code in this example ...

    list
    |> Enum.take(5)
    |> Enum.sort()
    |> case do
      [[_h | _t] | _] -> true
      _ -> false
    end

... should be refactored to look like this:

    maybe_nested_lists =
      list
      |> Enum.take(5)
      |> Enum.sort()

    case maybe_nested_lists do
      [[_h | _t] | _] -> true
      _ -> false
    end

... or create a new function:

    list
    |> Enum.take(5)
    |> Enum.sort()
    |> contains_nested_list?()

Piping to blocks may be harder to read because it can be said that it obscures intentions
and increases cognitive load on the reader. Instead, prefer introducing variables to your code or
new functions when it may be a sign that your function is getting too complicated and/or has too many concerns.

Like all `Readability` issues, this one is not a technical concern, but you can improve the odds of others reading
and understanding the intent of your code by making it easier to follow.
