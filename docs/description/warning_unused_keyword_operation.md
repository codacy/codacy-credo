The result of a call to the Keyword module's functions has to be used.

While this is correct ...

    def clean_and_verify_options!(keywords) do
      keywords = Keyword.delete(keywords, :debug)

      if Enum.length(keywords) == 0, do: raise "OMG!!!1"

      keywords
    end

... we forgot to save the result in this example:

    def clean_and_verify_options!(keywords) do
      Keyword.delete(keywords, :debug)

      if Enum.length(keywords) == 0, do: raise "OMG!!!1"

      keywords
    end

Keyword operations never work on the variable you pass in, but return a new
variable which has to be used somehow.
