defmodule MSON.ConfigError do
  defexception [:message]
end

defmodule MSON.Config do
  @moduledoc """
  Defines a struct used for configuring the parser behavior.

  defstruct namespace: nil, # The root module which will define the namespace of generated modules
            schema: "",     # The schema as a string, either provided direct, or read from file
            inject: false   # Flag which determines whether the types loaded are injected in the 'using' module.
                            # `inject: true` requires only with a single type defined, since no more than one struct
                            # can be defined per-module.
  """
  defstruct namespace: nil,
            schema: "",
            inject: false

  def new(values) do
    Enum.reduce(values, %__MODULE__{}, fn
      {key, value}, obj ->
        if Map.has_key?(obj, key) do
          Map.put(obj, key, value)
        else
          obj
        end
    end)
  end
end
