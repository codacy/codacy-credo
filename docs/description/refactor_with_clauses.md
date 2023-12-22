`with` statements are useful when you need to chain a sequence
of pattern matches, stopping at the first one that fails.

But sometimes, we go a little overboard with them (pun intended).

If the first or last clause in a `with` statement is not a `<-` clause,
it still compiles and works, but is not really utilizing what the `with`
macro provides and can be misleading.

    with ref = make_ref(),
         {:ok, user} <- User.create(ref),
         :ok <- send_email(user),
         Logger.debug("Created user: #{inspect(user)}") do
      user
    end

Here, both the first and last clause are actually not matching anything.

If we move them outside of the `with` (the first ones) or inside the body
of the `with` (the last ones), the code becomes more focused and .

This `with` should be refactored like this:

    ref = make_ref()

    with {:ok, user} <- User.create(ref),
         :ok <- send_email(user) do
      Logger.debug("Created user: #{inspect(user)}")
      user
    end
