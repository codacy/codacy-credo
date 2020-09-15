Aliases which are not completely renamed using the `:as` option are easier to follow.

    # preferred

    def MyModule do
      alias MyApp.Module1

      def my_function(foo) do
        Module1.run(foo)
      end
    end

    # NOT preferred

    def MyModule do
      alias MyApp.Module1, as: M1

      def my_function(foo) do
        # what the heck is `M1`?
        M1.run(foo)
      end
    end

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
