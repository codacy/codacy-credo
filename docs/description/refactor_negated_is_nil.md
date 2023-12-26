We should avoid negating the `is_nil` predicate function.

For example, the code here ...

    def fun(%{external_id: external_id, id: id}) when not is_nil(external_id) do
       # ...
    end

... can be refactored to look like this:

    def fun(%{external_id: nil, id: id}) do
      # ...
    end

    def fun(%{external_id: external_id, id: id}) do
      # ...
    end

... or even better, can match on what you were expecting on the first place:

    def fun(%{external_id: external_id, id: id}) when is_binary(external_id) do
      # ...
    end

    def fun(%{external_id: nil, id: id}) do
      # ...
    end

    def fun(%{external_id: external_id, id: id}) do
      # ...
    end

Similar to negating `unless` blocks, the reason for this check is not
technical, but a human one. If we can use the positive, more direct and human
friendly case, we should.
