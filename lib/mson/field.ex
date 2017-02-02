defmodule MSON.Field do
  @moduledoc """
  Field definitions in mson
  """

  defstruct name: nil,
            type: :string,
            value: nil

  def new(opts) do
    name = Keyword.get opts, :name
    type = Keyword.get opts, :type, :string
    value = Keyword.get opts, :value, nil

    %__MODULE__{name: name, type: type, value: value}
  end

end
