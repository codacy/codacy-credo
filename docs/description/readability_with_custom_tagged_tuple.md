Avoid using tags for error reporting.

Consider the following code:

    with {:resource, {:ok, resource}} <- {:resource, Resource.fetch(user)},
         {:authz, :ok} <- {:authz, Resource.authorize(resource, user)} do
      do_something_with(resource)
    else
      {:resource, _} -> {:error, :not_found}
      {:authz, _} -> {:error, :unauthorized}
    end

This code injects placeholder tags such as `:resource` and `:authz` for the purpose of error
reporting.

Instead, extract each validation into a separate helper function which returns error
information immediately:

    defp find_resource(user) do
      with :error <- Resource.fetch(user), do: {:error, :not_found}
    end

    defp authorize(resource, user) do
      with :error <- Resource.authorize(resource, user), do: {:error, :unauthorized}
    end

At this point, the validation chain in `with` becomes clearer and easier to understand:

    with {:ok, resource} <- find_resource(user),
         :ok <- authorize(resource, user),
         do: do_something(user)
