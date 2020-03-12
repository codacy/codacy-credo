Aliases which are not completely renamed using the `:as` option are easier to follow.

    # preferred

    alias MyApp.Module1

    # NOT preferred

    alias MyApp.Module1, as: M1

Like all `Readability` issues, this one is not a technical concern.
But you can improve the odds of others reading and liking your code by making
it easier to follow.
