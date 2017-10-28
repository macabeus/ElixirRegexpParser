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

  def parser_braces_full() do # {n,m}
    pipe([
      quantifier_brace_open(), integer(), comma(), integer(), quantifier_brace_close()
    ], fn p -> [_, min, _, max, _] = p; %Quantifier{min: min, max: max} end)
  end

  def parser_braces_at_least() do # {n,}
    pipe([
      quantifier_brace_open(), integer(), comma(), quantifier_brace_close()
    ], fn p -> [_, min, _, _] = p; %Quantifier{min: min} end)
  end

  def parser_braces_exactly() do # {n}
    pipe([
      quantifier_brace_open(), integer(), quantifier_brace_close()
    ], fn p -> [_, value, _] = p; %Quantifier{min: value, max: value} end)
  end

  # Parser for {n,m}
  defparser quantifier_brace_open(%ParserState{status: :ok, column: col, input: <<?{::utf8,rest::binary>>, results: results} = state) do
    %{state | :column => col + 1, :input => rest, :results => ["{"|results]}
  end
  defp quantifier_brace_open_impl(%ParserState{status: :ok, line: line, column: col, input: <<c::utf8,_::binary>>} = state) do
    %{state | :status => :error, :error => "Expected { found `#{<<c::utf8>>}` at line #{line}, column #{col + 1}."}
  end
  defp quantifier_brace_open_impl(%ParserState{status: :ok, input: <<>>} = state) do
    %{state | :status => :error, :error => "Expected {, but hit end of input."}
  end

  defparser comma(%ParserState{status: :ok, column: col, input: <<?,::utf8,rest::binary>>, results: results} = state) do
    %{state | :column => col + 1, :input => rest, :results => [","|results]}
  end
  defp comma_impl(%ParserState{status: :ok, line: line, column: col, input: <<c::utf8,_::binary>>} = state) do
    %{state | :status => :error, :error => "Expected , found `#{<<c::utf8>>}` at line #{line}, column #{col + 1}."}
  end
  defp comma_impl(%ParserState{status: :ok, input: <<>>} = state) do
    %{state | :status => :error, :error => "Expected ,, but hit end of input."}
  end

  defparser quantifier_brace_close(%ParserState{status: :ok, column: col, input: <<?}::utf8,rest::binary>>, results: results} = state) do
    %{state | :column => col + 1, :input => rest, :results => ["}"|results]}
  end
  defp quantifier_brace_close_impl(%ParserState{status: :ok, line: line, column: col, input: <<c::utf8,_::binary>>} = state) do
    %{state | :status => :error, :error => "Expected } found `#{<<c::utf8>>}` at line #{line}, column #{col + 1}."}
  end
  defp quantifier_brace_close_impl(%ParserState{status: :ok, input: <<>>} = state) do
    %{state | :status => :error, :error => "Expected }, but hit end of input."}
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
