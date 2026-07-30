The result of a call to the Map module's functions has to be used.

While this is correct ...

    def clean_and_verify_options!(map) do
      map = Map.delete(map, :debug)

      if Enum.length(map) == 0, do: raise "OMG!!!1"

      map
    end

... we forgot to save the result in this example:

    def clean_and_verify_options!(map) do
      Map.delete(map, :debug)

      if Enum.length(map) == 0, do: raise "OMG!!!1"

      map
    end

Map operations never work on the variable you pass in, but return a new
variable which has to be used somehow.
