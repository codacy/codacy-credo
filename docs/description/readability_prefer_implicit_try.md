Prefer using an implicit `try` rather than explicit `try` if you try to rescue
anything the function does.

For example, this:

    def failing_function(first) do
      try do
        to_string(first)
      rescue
        _ -> :rescued
      end
    end

Can be rewritten without `try` as below:

    def failing_function(first) do
      to_string(first)
    rescue
      _ -> :rescued
    end

This emphazises that you really want to try/rescue anything the function does,
which might be important for other contributors so they can reason about adding
code to the function.

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
