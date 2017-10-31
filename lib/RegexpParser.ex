defmodule RegexpParser do
  use Combine

  import RegexpParser.BackslashLetter
  import RegexpParser.List
  import RegexpParser.Character

  def parse(regexp) do
    [p] = Combine.parse(regexp,
      many(
        choice([
          parser_list(),
          parser_backslashletter(),
          parser_character()
        ])
      )
    )

    p
  end
end
