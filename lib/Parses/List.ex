defmodule RegexpParser.List do
  @moduledoc "Parse a list, like [abc] or [^abc]."

  use Combine
  use Combine.Helpers
  import RegexpParser.Quantifier

  @enforce_keys [:except, :characters, :quantifier]
  defstruct [:except, :characters, :quantifier]

  def parser_list() do
    map(
      pair_both(
        list(),
        parser_quantifier()
      ),
      fn {[e, c], q} -> %RegexpParser.List{except: e, characters: c, quantifier: q} end
    )
  end

  def list() do
    sequence([
      ignore(char("[")),
      map(option(char("^")), &(&1 == "^")),
      many(satisfy(char(), &(&1 != "]"))),
      ignore(char("]"))
    ])
  end
end
