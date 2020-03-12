Provide module parts in a required order.

    # preferred

    defmodule MyMod do
      @moduledoc "moduledoc"
      use Foo
      import Bar
      alias Baz
      require Qux
    end
