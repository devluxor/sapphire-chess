require_relative 'board.rb'
require_relative 'ai.rb'
require_relative 'human_input_conversion.rb'
require_relative 'castling.rb'

class Player
  include Castling

  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end
end

class Computer < Player
  include AI

  def get_move
    computer_chooses_move
  end
end

class Human < Player
  include HumanInputConversion
  
  def get_move
    algebraic_input
  end
end
