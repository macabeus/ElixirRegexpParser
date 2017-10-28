defmodule RegexpParser.Backslash do
  @moduledoc "Parse a backslash."

  use Combine
  use Combine.Helpers
  alias Combine.ParserState

  defparser backslash(%ParserState{status: :ok, column: col, input: <<?\\::utf8,rest::binary>>, results: results} = state) do
    %{state | :column => col + 1, :input => rest, :results => ["\\"|results]}
  end

  defp backslash_impl(%ParserState{status: :ok, line: line, column: col, input: <<c::utf8,_::binary>>} = state) do
    %{state | :status => :error, :error => "Expected \\ found `#{<<c::utf8>>}` at line #{line}, column #{col + 1}."}
  end

  defp backslash_impl(%ParserState{status: :ok, input: <<>>} = state) do
    %{state | :status => :error, :error => "Expected \\, but hit end of input."}
  end
end
