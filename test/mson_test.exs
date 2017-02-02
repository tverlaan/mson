defmodule MSONTest do
  use ExUnit.Case

  test "Basic structure" do
    defmodule Basic do
      use MSON, """
        # Foo

        + bar (string)
        + qux (string)

        """
    end

    m = Basic.Foo

    assert %{:__struct__ => ^m, :bar => "qux"} = Basic.Foo.new(bar: "qux")
  end

  test "Basic structure injected into module" do
    defmodule InjectBasic do
      use MSON, ["""
        # Inject Basic

        + name (string)
        + type (string)

        """, inject: true]
    end

    m = InjectBasic

    assert %{:__struct__ => ^m} = InjectBasic.new(name: nil, type: nil)
  end
end
