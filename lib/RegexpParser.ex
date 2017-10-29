defmodule RegexpParser do
  use Combine

  import RegexpParser.BackslashLetter
  import RegexpParser.List

  def parse(regexp) do
    Combine.parse(regexp,
      many(
        choice([
          parser_list(),
          parser_backslashletter(),
          char()
        ])
      )
    )
  end
end
