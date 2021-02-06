defmodule LiveStruct.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_struct,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "lets you use structs as assigns",
      licenses: ["MIT"],
      links: [
        github: "https://github.com/ityonemo/live_struct"
      ],
      source_url: "https://github.com/ityonemo/live_struct"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
