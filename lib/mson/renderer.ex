defmodule MSON.Renderer do
  @moduledoc """
  This module is responsible for rendering the Earmark output to a usable output for the builder.
  """

  alias MSON.Config
  alias Earmark.Block

  def render(blocks, config) do
    render_block(blocks, [], config)
    |> behead
  end

  defp render_block([], result, _), do: result

  # heading, start a new message
  defp render_block([ %Block.Heading{content: content} | rest], acc, config) do
    acc = acc |>  behead

    # concat the new msg name
    msg_mod = render_head(content, config)

    # add an empty head to acc
    render_block(rest, [ {{:msg, msg_mod},[]} | acc ], config)
  end

  # we encounter a list and there is something looking like a msg def
  defp render_block([ %Block.List{blocks: blocks} | rest], [{_, _} | _] = acc, config) do
    # parse all sub blocks
    acc = render_block(blocks, acc, config)

    render_block(rest, acc, config)
  end

  # an actual list item, tricky part begins
  defp render_block([ %Block.ListItem{blocks: blocks} | rest], [ {head, body} | t] = _, config) do
    # render all the listitems, return sub msgs and body
    { sub, body } = render_list(blocks, head, body, config)

    # append the submsgs to the acc
    render_block(rest, [{head, body} | t] ++ sub, config)
  end

  # we didn't match before, skip this element
  defp render_block([ _ | rest], acc, config) do
    render_block(rest, acc, config)
  end

  defp render_list([ %Block.Para{lines: [line | _]} | rest], {:msg, head}, body, %Config{namespace: ns} = config) do
    # define a msg_mod
    msg_mod = render_head(line, %Config{config | namespace: Module.concat(ns, head)})

    # go in deep to define another _sub_ msg
    sub_msg = render_block(rest, [{{:msg, msg_mod}, []}], config)
    |> behead

    # if we found anything add it
    res = case sub_msg do
      [{{:msg, msg_name}, _}] -> [name: msg_name, type: msg_name]
      [] -> render_line(line)
    end

    # add to body
    body = [MSON.Field.new(res) | body]

    {sub_msg, body}
  end

  defp render_list(_, _, body, _) do
    {[], body}
  end

  defp render_head(_, %Config{namespace: ns, inject: true}), do: ns
  defp render_head(head, %Config{namespace: ns}) do
    ns
    |> Module.concat(
      head
      |> String.split
      |> List.first
      |> String.downcase
      |> Macro.camelize)
  end

  defp render_line(line) do
    name = Regex.run(~r/^[a-zA-Z]+/, line)
      |> List.first
      |> String.to_atom

    value = case Regex.run(~r/:\s\s*([a-zA-Z0-9_]+)/, line) do
      [_, v]  -> v
      _       -> nil
    end

    type = case Regex.run(~r/\(([a-zA-Z]+)\)/, line) do
      [_, t]  -> String.to_atom(t)
      _       -> nil
    end

    [name: name, type: type, value: value]
  end

  # remove the last 'empty' head
  defp behead([{_, []} | messages ]), do: messages
  defp behead(messages), do: messages

end
