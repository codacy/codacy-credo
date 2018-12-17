Creating atoms from unknown or external sources dynamically is a potentially
unsafe operation because atoms are not garbage-collected by the runtime.

Creating an atom from a string or charlist should be done by using

    String.to_existing_atom(string)

or

    List.to_existing_atom(charlist)

Module aliases should be constructed using

    Module.safe_concat(prefix, suffix)

or

    Module.safe_concat([prefix, infix, suffix])

