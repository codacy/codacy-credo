defmodule Test do
  use Check.Test2

  alias CodeStuff

  # TODO: how is this `case` necessary
  defp prefix_and_suffix(exception_name) do
    name_list = exception_name |> Name.last() |> Name.split_pascal_case()
    prefix = List.first(name_list)
    suffix = List.last(name_list)

    {prefix, suffix}
  end
end
