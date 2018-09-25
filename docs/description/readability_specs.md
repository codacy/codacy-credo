Functions, callbacks and macros need typespecs.

Adding typespecs gives tools like Dialyzer more information when performing
checks for type errors in function calls and definitions.

    @spec add(integer, integer) :: integer
    def add(a, b), do: a + b

Functions with multiple arities need to have a spec defined for each arity:

    @spec foo(integer) :: boolean
    @spec foo(integer, integer) :: boolean
    def foo(a), do: a > 0
    def foo(a, b), do: a > b

The check only considers whether the specification is present, it doesn't
perform any actual type checking.
