defmodule RegexpParser do
  use Combine

  import RegexpParser.BackslashLetter
  import RegexpParser.List
  import RegexpParser.Dot
  import RegexpParser.Character

  def parse(regexp) do
    [p] = Combine.parse(regexp,
      many(
        choice([
          parser_list(),
          parser_backslashletter(),
          parser_dot(),
          parser_character()
        ])
      )
    )

    p
  end
end
