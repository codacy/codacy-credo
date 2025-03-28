Avoid piping into anonymous functions.

The code in this example ...

    def my_fun(foo) do
      foo
      |> (fn i -> i * 2 end).()
      |> my_other_fun()
    end

... should be refactored to define a private function:

    def my_fun(foo) do
      foo
      |> times_2()
      |> my_other_fun()
    end

    defp timex_2(i), do: i * 2

... or use `then/1`:

    def my_fun(foo) do
      foo
      |> then(fn i -> i * 2 end)
      |> my_other_fun()
    end

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
