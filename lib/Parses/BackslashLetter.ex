defmodule RegexpParser.BackslashLetter do
  @moduledoc "Parse a backslash-letter metacharacter, like \\s, \\S, \\d, \\D, \\w, \\W, \\b and \\B."

  use Combine
  use Combine.Helpers
  alias Combine.ParserState
  import RegexpParser.Quantifier

  @metacharacters [?s, ?S, ?d, ?D, ?w, ?W, ?b, ?B]

  @enforce_keys [:backslash_letter]
  defstruct [:backslash_letter, :quantifier]

  def parser_backslashletter() do
    map(
      sequence([
        ignore(char("\\")),
        backslashletter(),
        parser_quantifier()
      ]),
      fn
        [l, q] -> %RegexpParser.BackslashLetter{backslash_letter: l, quantifier: q}
        [l] -> %RegexpParser.BackslashLetter{backslash_letter: l}
      end
    )
  end

  # Parser for valids letters at backslash metacharacter
  defparser backslashletter(%ParserState{status: :ok, column: col, input: <<c::utf8,rest::binary>>, results: results} = state)
    when c in @metacharacters do
      character = case c do
        ?s -> "s"
        ?S -> "S"
        ?d -> "d"
        ?D -> "D"
        ?w -> "w"
        ?W -> "W"
        ?b -> "b"
        ?B -> "B"
      end
      %{state | :column => col + 1, :input => rest, :results => [character|results]}
  end
  defp backslashletter_impl(%ParserState{status: :ok, line: line, column: col, input: <<c::utf8,_::binary>>} = state) do
    %{state | :status => :error, :error => "Expected a metacharacter found `\\#{<<c::utf8>>}` at line #{line}, column #{col}."}
  end
  defp backslashletter_impl(%ParserState{status: :ok, input: <<>>} = state) do
    %{state | :status => :error, :error => "Expected a metacharacter, but hit end of input."}
  end
end
