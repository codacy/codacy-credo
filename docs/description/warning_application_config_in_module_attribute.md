Module attributes are evaluated at compile time and not at run time. As
a result, certain configuration read calls made in your module attributes
may work as expected during local development, but may break once in a
deployed context.

This check analyzes all of the module attributes present within a module,
and validates that there are no unsafe calls.

These unsafe calls include:

- `Application.fetch_env/2`
- `Application.fetch_env!/2`
- `Application.get_all_env/1`
- `Application.get_env/3`
- `Application.get_env/2`

As of Elixir 1.10 you can leverage `Application.compile_env/3` and
`Application.compile_env!/2` if you wish to set configuration at
compile time using module attributes.
