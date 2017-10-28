defmodule RegexpParser do
  use Combine

  import RegexpParser.Backslash
  import RegexpParser.BackslashLetter
  import RegexpParser.Quantifier

  def parse(regexp) do
    Combine.parse(regexp,
      many(
        either(
          backslash_letter(),
          char()
        )
      )
    )
  end

  def backslash_letter() do
    pair_both(
      both(
        backslash(), parser_backslash_letter(), &("#{&1}#{&2}")
      ),
      parser_quantifier()
    )
  end
end
