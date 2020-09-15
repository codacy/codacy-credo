When capturing a parameter using pattern matching you can either put the parameter name before or after the value
i.e.

    def parse({:ok, values} = pair)

or

    def parse(pair = {:ok, values})

Neither of these is better than the other, but it seems a good idea not to mix the two patterns in the same codebase.

While this is not necessarily a concern for the correctness of your code,
you should use a consistent style throughout your codebase.
