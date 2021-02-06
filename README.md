# LiveStruct

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

## Documentation

Documentation is published on [HexDocs](https://hexdocs.pm).
Once published, the docs can be found at [https://hexdocs.pm/live_struct](https://hexdocs.pm/live_struct).

