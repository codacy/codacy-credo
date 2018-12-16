The result of a call to the Tuple module's functions has to be used.

While this is correct ...

    def remove_magic_item!(tuple) do
      tuple = Tuple.delete_at(tuple, 0)

      if Enum.length(tuple) == 0, do: raise "OMG!!!1"

      tuple
    end

... we forgot to save the result in this example:

    def remove_magic_item!(tuple) do
      Tuple.delete_at(tuple, 0)

      if Enum.length(tuple) == 0, do: raise "OMG!!!1"

      tuple
    end

Tuple operations never work on the variable you pass in, but return a new
variable which has to be used somehow.
