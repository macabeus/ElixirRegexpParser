defmodule RegexpParser.Dot do
  @moduledoc "Parse a dot metacharacter."

  use Combine
  use Combine.Helpers
  import RegexpParser.Quantifier

  defstruct [:quantifier]

  def parser_dot() do
    map(
      sequence([
        ignore(char(".")),
        parser_quantifier()
      ]),
      fn
        [q] -> %RegexpParser.Dot{quantifier: q}
        [] -> %RegexpParser.Dot{}
      end
    )
  end

end
