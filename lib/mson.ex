defmodule MSON do
  @moduledoc """
  Define your struct definitions in Markdown
  """
  alias MSON.{Config, Renderer, Builder}
  alias Earmark.Parser

  defmacro __using__(opts) do
    namespace = __CALLER__.module
    config = case opts do
      << schema :: binary >> ->
        %Config{namespace: namespace, schema: schema}
      [<< schema :: binary >>, inject: true] ->
        %Config{namespace: namespace, schema: schema, inject: true}
    end

    config
    |> parse(__CALLER__)
    |> Builder.define(config)
  end

  defp parse(%Config{schema: schema} = config, _) do
    schema
    |> String.split(~r/\r\n?|\n/)
    |> Parser.parse()
    |> elem(0)
    |> Renderer.render(config)
  end

end
