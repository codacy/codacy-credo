Prefer calling functions directly if the number of arguments is known
at compile time instead of using `apply/2` and `apply/3`.

Example:

    # preferred

    fun.(arg_1, arg_2, ..., arg_n)

    module.function(arg_1, arg_2, ..., arg_n)

    # NOT preferred

    apply(fun, [arg_1, arg_2, ..., arg_n])

    apply(module, :function, [arg_1, arg_2, ..., arg_n])
