`DateTime.utc_now/1` is more efficient than `DateTime.utc_now/0 |> DateTime.truncate/1`.

For example, the code here ...

    DateTime.utc_now() |> DateTime.truncate(:second)
    NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

... can be refactored to look like this:

    DateTime.utc_now(:second)
    NaiveDateTime.utc_now(:second)

The reason for this is not just performance, because no separate function
call is required, but also brevity of the resulting code.
