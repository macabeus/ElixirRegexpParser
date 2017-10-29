defmodule RegexpParser.Quantifier do
  @moduledoc "Parse a quantifier. A quantifier is a optional +, *, ? or {n,m}."

  use Combine
  use Combine.Helpers
  alias Combine.ParserState
  alias RegexpParser.Quantifier

  @enforce_keys [:min]
  defstruct [:min, :max]

  def parser_quantifier() do
    choice([
      parser_braces_full(),
      parser_braces_at_least(),
      parser_braces_exactly(),
      quantifier_abbreviation()
    ])
  end

  # Parser for explit quantifier
  def parser_braces_full() do # {n,m}
    pipe([
      char("{"), integer(), char(","), integer(), char("}")
    ], fn p -> [_, min, _, max, _] = p; %Quantifier{min: min, max: max} end)
  end

  def parser_braces_at_least() do # {n,}
    pipe([
      char("{"), integer(), char(","), char("}")
    ], fn p -> [_, min, _, _] = p; %Quantifier{min: min} end)
  end

  def parser_braces_exactly() do # {n}
    pipe([
      char("{"), integer(), char("}")
    ], fn p -> [_, value, _] = p; %Quantifier{min: value, max: value} end)
  end

  # Parse for +, * and ?
  @metacharacters [?*, ?+, ??]

  defparser quantifier_abbreviation(%ParserState{status: :ok, column: col, input: <<c::utf8,rest::binary>>, results: results} = state)
    when c in @metacharacters do
      character = case c do
        ?* -> %Quantifier{min: 0}
        ?+ -> %Quantifier{min: 1}
        ?? -> %Quantifier{min: 0, max: 1}
      end

      %{state | :column => col + 1, :input => rest, :results => [character|results]}
  end
  defp quantifier_abbreviation_impl(%ParserState{status: :ok} = state) do
    state
  end
end
