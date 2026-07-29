Invoking mix test from the command line will run the tests in each file
matching the pattern `*_test.exs` found in the test directory of your project.

(from the `ex_unit` docs)

This test ensures that files containing `use ExUnit.Case` and related cases are only
used in files ending with `_test.exs`.

If you have a file named differently (say, `test_my_module.exs`), you will be able to
run `mix test test/test_my_module.exs` and see the tests run. This can mislead you
into believing that subsequently running the full test suite (`mix test`) will also
test your file.
