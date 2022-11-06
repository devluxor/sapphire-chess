require_relative 'board.rb'
require_relative 'ai.rb'
require_relative 'user_input.rb'


require 'pry'

class Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end
end

class Computer < Player
  include AI

  attr_reader :board

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
