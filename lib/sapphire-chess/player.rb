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

  def maximizing_player?
    color == :white
  end
end

class Computer < Player
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
