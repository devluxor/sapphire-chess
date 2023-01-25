# 1.1.0 (January 25, 2023)

## Bug fixes:

  - Fix `#get_move` invocation (correct: `#select_move`) in `human_input_validation.rb`.
  - Pawns were not promoted correctly due to an error in `Pawn#available_moves`.

## Enhancement:

  - Fine tune various pieces' location values for not hard difficulties
  - The game now only allows legal movements. For example, when a player is in check,
  the only valid movements are movements that move the player out of check.
  - The white computer player now randomly chooses a classic opening, and the black computer player can answer with an appropriate defense. 

## Documentation:

  - Fix various typos in documentation.

## Style:

  - I've abstracted logic in some methods to make them more readable, and changed a few variable names for clarity.

## Current worries:

  - The hardest difficulty is still too slow, I'm studying how to improve the performance of the method, which builds recursively a huge n-tree.

# 1.0.1 (January 16, 2023)

## Enhancement:

  - Remove useless assignments in `ai.rb`
  - Fine tune pawn location values for not hard difficulties

## Documentation:

  - Update `README.md`
  - Correct typo in `sapphire-chess.gemspec`


# 1.0.0 (January 15, 2023)

Initial release.

Please, visit https://medium.com/@lucas.sorribes/nostromo-my-ruby-chess-journey-part-i-7ef544b547a5 for a very detailed account of how I wrote this game.