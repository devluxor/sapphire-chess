require_relative 'board.rb'
require_relative 'ai.rb'
require_relative 'user_input.rb'


require 'pry'

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Computer < Player
  include AI

  attr_reader :board

  def initialize(color, board)
    super(color)
    @board = board
  end

  def get_position
    computer_chooses_movement
  end
end

class Human < Player
  include UserInput
  
  def get_position
    algebraic_input
  end
end
