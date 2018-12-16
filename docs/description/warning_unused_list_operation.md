The result of a call to the List module's functions has to be used.

While this is correct ...

    def sort_usernames(usernames) do
      usernames = List.flatten(usernames)

      List.sort(usernames)
    end

... we forgot to save the result in this example:

    def sort_usernames(usernames) do
      List.flatten(usernames)

      List.sort(usernames)
    end

List operations never work on the variable you pass in, but return a new
variable which has to be used somehow.
