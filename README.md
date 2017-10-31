<p align="center">
  <a href="">
    <img alt="Logo" src="https://i.imgur.com/AEa1Gwf.png" width="600px">
  </a>
</p>

A simple project (for studying purposes) to parse regex with [combine library](https://github.com/bitwalker/combine).

```elixir
RegexpParser.parse("er?lx.r\\s[^abc]+\\w?\\W{2}\\d") 
> [
    %RegexpParser.Character{char: "e", quantifier: nil},
    %RegexpParser.Character{char: "r", quantifier: %RegexpParser.Quantifier{max: 1, min: 0}},
    %RegexpParser.Character{char: "l", quantifier: nil},
    %RegexpParser.Character{char: "x", quantifier: nil},
    %RegexpParser.Dot{quantifier: nil},
    %RegexpParser.Character{char: "r", quantifier: nil},
    %RegexpParser.BackslashLetter{backslash_letter: "s", quantifier: nil},
    %RegexpParser.List{characters: ["a", "b", "c"], except: true, quantifier: %RegexpParser.Quantifier{max: nil, min: 1}},
    %RegexpParser.BackslashLetter{backslash_letter: "w", quantifier: %RegexpParser.Quantifier{max: 1, min: 0}},
    %RegexpParser.BackslashLetter{backslash_letter: "W", quantifier: %RegexpParser.Quantifier{max: 2, min: 2}},
    %RegexpParser.BackslashLetter{backslash_letter: "d", quantifier: nil}
  ]
 ```
 
 # TODO
 
| Metacharacters   | Implemented |
| -----------------|-------------|
| Dot              | Yes!        |
| Backslash-letter | Yes!        |
| Lists            | Yes!        |
| Quantifiers      | Yes!        |
| Anchors          | No          |
| Escape           | No          |
| Or               | No          |
| Group            | No          |
