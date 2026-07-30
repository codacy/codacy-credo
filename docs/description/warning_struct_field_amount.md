Avoid structs with 32 or more fields.

Structs in Elixir are implemented as compile-time maps, which have a
predefined amount of fields.

When structs have 32 or more fields, their internal representation in
the Erlang Virtual Machines changes, potentially leading to bloating
and higher memory usage.

https://hexdocs.pm/elixir/1.19.0/code-anti-patterns.html#structs-with-32-fields-or-more
