# MSON

[![Build Status](https://travis-ci.org/tverlaan/mson.svg?branch=master)](https://travis-ci.org/tverlaan/mson)
[![Hex.pm Version](http://img.shields.io/hexpm/v/mson.svg?style=flat)](https://hex.pm/packages/mson)

A library for defining your structs in Markdown. It will be compiled to a module with documentation, a struct and some helper functions like `new`. Depending on the options you give it it creates a new module or injects it in the current module. Any extra text (like paragraphs) will be present in the documentation but not in the structs. Please see the examples for more details.

This module implements some features of the MSON spec of [Apiary](https://github.com/apiaryio/mson). Adding new features is currently not on the roadmap.

Usage is inspired by the excellent [protobuf library](https://github.com/bitwalker/exprotobuf).

## Features


## Examples

### Creating "sub"-module

```elixir
defmodule MyProject do
  use MSON, """
  # Data

  + name (string)
  + type (string)

  """
end

%MyProject.Data{name: nil, type: nil}
```

### Injecting in current module

You can define your own functions.

```elixir
defmodule MyProject.Data do
  use MSON, ["""
  # Data

  + name (string)
  + type (string)

  """, inject: true]
end

%MyProject.Data{name: nil, type: nil}
```

## Installation

Add it to your `mix.exs` file like either one of this:
```elixir
defp deps do
  [
    {:mson, "~> 0.1"}
  ]
end
```

## Todo

Write documentation.

## Contributing

Fork and send a PR! Try to be a good citizen ;-)
