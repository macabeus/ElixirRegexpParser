defmodule RegexpParser do
  use Combine

  import RegexpParser.BackslashLetter

  def parse(regexp) do
    Combine.parse(regexp,
      many(
        either(
          parser_backslashletter(),
          char()
        )
      )
    )
  end
end
