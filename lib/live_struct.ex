defmodule LiveStruct do
  @moduledoc """
  LiveStruct is a tool that lets you use a struct as the 'assigns'
  of a `Phoenix.LiveView`.

  Note this is probably done, but it's still alpha, and it *might* cause
  problems with LiveView in the future.

  ## Installation

  The package can be installed by adding `live_struct` to your list of
  dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:live_struct, "~> 0.1.0", runtime: false}
    ]
  end
  ```

  ## Usage

  Use LiveStruct as follows:

  ```elixir
  defmodule MyAppWeb.PageLive do
    use MyAppWeb, :live_view
    use LiveStruct  # <-- add this

    defassigns [:value, :other_value, :yet_another_value] # <-- and this

    # optional:
    @opaque state :: %__MODULE__{
      value: String.t,
      other_value: [atom],
      yet_another_value: integer,
    }

    # also optional:
    @opaque socket :: %Phoenix.LiveView.Socket{
      assigns: state
    }

    # ninja in your struct here:
    @impl true
    def mount(params, session, socket) do
      ... #your mount code
      {:ok, struct_assigns(socket)} #<-- with this code.
    end
  end
  ```
  """


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
