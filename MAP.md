## Classes:

#### Engine:
  - `lib/engine.rb`

The `ChessEngine` class controls the game flow and logic, via the `play` interface, mixing-in `Display` and `HumanMoveValidation`. It coordinates the board renderization via `BoardRenderer`, the turn number update, the display of messages and player score via `Display`, controls input validation, move legality and move input conversion, and game over logic. I will write a more fine-tuned logic for this before long.

At the moment, the game only allows the human player to play with whites, but this will change in the near future, as I'd like to implement a color selection randomization.

I'd also like to add an AI vs. AI mode.

---

#### Board functionality:
  - `lib/board_analysis.rb`
  - `lib/board_evaluation.rb`
  - `lib/board_general.rb`
  - `lib/board_renderer.rb`

#### Pieces functionality:
  - `lib/bishop.rb`
  - `lib/king.rb`
  - `lib/knight.rb`
  - `lib/movement.rb`
  - `lib/pawn.rb`
  - `lib/piece.rb`
  - `lib/queen.rb`
  - `lib/rook.rb`

#### Player:
  - `lib/player.rb`

#### Input Validation And Conversion:
  - `lib/human_input_validation.rb`
  - `lib/human_move_validation.rb`







