Multi alias expansion makes module uses harder to search for in large code bases.

    # preferred

    alias Module.Foo
    alias Module.Bar

    # NOT preferred

    alias Module.{Foo, Bar}

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
