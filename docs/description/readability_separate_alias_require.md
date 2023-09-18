All instances of `alias` should be consecutive within a file.
Likewise, all instances of `require` should be consecutive within a file.

For example:

    defmodule Foo do
      require Logger
      alias Foo.Bar

      alias Foo.Baz
      require Integer

      # ...
    end

should be changed to:

    defmodule Foo do
      require Integer
      require Logger

      alias Foo.Bar
      alias Foo.Baz

      # ...
    end

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
