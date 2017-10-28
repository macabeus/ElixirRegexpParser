defmodule RegexpParser.Quantifier do
  @moduledoc "Parse a quantifier. A quantifier is a optional +, *, ? or {n, m}."
  # TODO: Needs implement suport to {n, m}

  use Combine
  use Combine.Helpers
  alias Combine.ParserState

  @metacharacters [?+, ?*, ??]

  defparser quantifier(%ParserState{status: :ok, column: col, input: <<c::utf8,rest::binary>>, results: results} = state)
    when c in @metacharacters do
      character = case c do
        ?+ -> "+"
        ?* -> "*"
        ?? -> "?"
      end

      %{state | :column => col + 1, :input => rest, :results => [character|results]}
  end
  defp quantifier_impl(%ParserState{status: :ok} = state) do
    state
  end
end
