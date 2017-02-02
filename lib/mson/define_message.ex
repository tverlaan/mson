defmodule MSON.DefineMessage do
  @moduledoc false
  alias MSON.Field
  alias MSON.Config

  def def_message(name, fields, %Config{inject: inject, schema: schema}) when is_list(fields) do
    struct_fields = record_fields(fields)
    # Inject everything in 'using' module
    if inject do
      quote location: :keep do
        @root __MODULE__
        fields = unquote(struct_fields)
        defstruct fields

        unquote(fields_methods(fields))
        unquote(meta_information())
        unquote(constructors(name))
      end
    # Or create a nested module, with use_in functionality
    else
      quote location: :keep do
        root   = __MODULE__
        fields = unquote(struct_fields)
        use_in = @use_in[unquote(name)]

        defmodule unquote(name) do
          @moduledoc """
          #{unquote(schema)}
          """
          @root root
          defstruct fields

          unquote(fields_methods(fields))
          unquote(meta_information())
          unquote(constructors(name))

          if use_in != nil do
            Module.eval_quoted(__MODULE__, use_in, [], __ENV__)
          end
        end
      end
    end
  end

  defp constructors(name) do
    quote location: :keep do
      def new(), do: struct(unquote(name))
      def new(values) when is_list(values) do
        Enum.reduce(values, new(), fn
          {key, value}, obj ->
            if Map.has_key?(obj, key) do
              Map.put(obj, key, value)
            else
              obj
            end
        end)
      end
    end
  end

  defp fields_methods(fields) do
    for %Field{name: name} = field <- fields do
      quote location: :keep do
        def defs(:field, unquote(name)), do: unquote(Macro.escape(field))
      end
    end
  end

  defp meta_information() do
    quote do
      def defs(),                   do: @root.defs
      def defs(:field, _),        do: nil
      defoverridable [defs: 0]
    end
  end

  defp record_fields(fields) do
    fields
    |> Enum.map(fn(field) ->
      case field do
        %Field{name: name} ->
          {name, nil}
        _ ->
          nil
      end
    end)
    |> Enum.reject(fn(field) -> is_nil(field) end)
  end

end
