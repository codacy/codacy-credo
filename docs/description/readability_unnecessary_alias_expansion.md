Alias expansion is useful but when aliasing a single module,
it can be harder to read with unnecessary braces.

    # preferred

    alias ModuleA.Foo
    alias ModuleA.{Foo, Bar}

    # NOT preferred

    alias ModuleA.{Foo}

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
