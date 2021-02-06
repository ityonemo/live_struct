defmodule LiveStruct do
  @doc false
  defmacro __using__(_) do
    quote do
      import LiveStruct, only: [defassigns: 1, struct_assigns: 1]

      @before_compile LiveStruct
    end
  end

  @doc false
  defmacro defassigns(assigns) do
    quote do
      defstruct unquote(assigns) ++ [:flash, :live_action]
    end
  end

  defmacro struct_assigns(socket) do
    quote do
      Map.put(
        unquote(socket),
        :assigns,
        struct(__MODULE__, unquote(socket).assigns)
      )
    end
  end

  @doc false
  defmacro __before_compile__(context) do
    keys =
      context.module
      |> Module.get_attribute(:struct)
      |> Map.keys()
      |> Enum.reject(&(&1 == :__struct__))

    quote do
      @behaviour Access
      @keys unquote(keys)
      @impl Access
      defdelegate fetch(struct, key), to: Map
      @impl Access
      defdelegate get_and_update(struct, key, function), to: Map
      @impl Access
      def pop(struct, key) when key in @keys do
        {Map.get(struct, key), %{struct | key => nil}}
      end

      def pop(_struct, _key), do: raise(KeyError)

      defimpl Enumerable do
        def count(struct) do
          struct
          |> Map.from_struct()
          |> Enumerable.Map.count()
        end

        def member?(struct, kv) do
          struct
          |> Map.from_struct()
          |> Enumerable.Map.member?(kv)
        end

        def slice(struct) do
          struct
          |> Map.from_struct()
          |> Enumerable.Map.slice()
        end

        def reduce(struct, acc, fun) do
          struct
          |> Map.from_struct()
          |> Enumerable.Map.reduce(acc, fun)
        end
      end
    end
  end
end
