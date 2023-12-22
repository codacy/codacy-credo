Structs create compile-time dependencies between modules.  Using a struct in a spec
will cause the module to be recompiled whenever the struct's module changes.

It is preferable to define and use `MyModule.t()` instead of `%MyModule{}` in specs.

Example:

    # preferred
    @spec a_function(MyModule.t()) :: any

    # NOT preferred
    @spec a_function(%MyModule{}) :: any
