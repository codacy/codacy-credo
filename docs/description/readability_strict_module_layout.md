Provide module parts in a required order.

    # preferred

    defmodule MyMod do
      @moduledoc "moduledoc"
      use Foo
      import Bar
      alias Baz
      require Qux
    end

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
