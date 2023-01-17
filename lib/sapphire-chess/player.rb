require_relative 'ai'
require_relative 'algebraic_conversion'
require_relative 'movement_rules/castling_rights'

class Player
  include CastlingRights

  attr_accessor :last_move
  attr_reader :color, :board, :history

  def initialize(color, board)
    @color = color
    @board = board
    @history = []
  end

  private

  def first_turn?
    history.empty?
  end

  def maximizing_player?
    color == :white
  end
end

class Computer < Player
  OPENINGS = {
    nf3: { probabilty: (1..50), move: [[7, 6], [5, 5]] }, # Most flexible white opening favored by many
    e4: { probabilty:  (51..75),  move: [[6, 4], [4, 4]] }, # The best and most famous white opening.
    d4: { probabilty:  (76..90),  move: [[6, 3], [4, 3]] }, # This can lead to the Queen's Gambit
    c4: { probabilty:  (91..100), move: [[6, 2], [4, 2]] }
  }.freeze

  DEFENSES = {
    [[7, 6], [5, 5]] => [[[1, 2], [3, 2]], [[0, 6], [2, 5]]].sample,
    [[6, 4], [4, 4]] => [[[1, 2], [3, 2]], [[1, 4], [3, 4]]].sample,
    [[6, 3], [4, 3]] => [[[0, 6], [2, 5]], [[1, 2], [2, 2]]].sample
  }.freeze

  include AI

  # depth: Levels of AI#minimax recursion.
  # Deeper means harder (computer can think `depth` turns ahead)
  # See Engine#set_difficulty
  attr_accessor :depth

  def select_move
    computer_chooses_move
  end
end

class Human < Player
  include AlgebraicConversion

  def select_move
    algebraic_input
  end
end
