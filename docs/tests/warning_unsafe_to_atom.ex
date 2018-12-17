##Patterns: warning_unsafe_to_atom
defmodule CredoSampleModule do
  def some_function(mapParameter) do
    mapParameter
    ##Warning: warning_unsafe_to_atom
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
