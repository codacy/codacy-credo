##Patterns: refactor_map_into
defmodule CredoSampleModule do
  def some_function(parameter1, parameter2) do
    [:apple, :banana, :carrot]
    |> Enum.map(&({&1, to_string(&1)}))
 ##Warning: refactor_map_into
    |> Enum.into(%{})
  end
end
