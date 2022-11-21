require_relative '../board.rb'
require_relative 'movement.rb'

require 'singleton'
require 'paint'

class NoPiece
  include Singleton

  def to_s
    '  '
  end

  def white
    '██'
  end
end

class Piece
  attr_reader :color, :board
  attr_accessor :location

  def initialize(board, location, color)
    @board = board
    @color = color
    @location = location
  end

  def to_s
    case color
    when :white then Paint[self.class::WHITE, :white]
    else Paint[self.class::BLACK, :blue]
    end
  end

  # Available moves that don't move us into check
  def safe_moves
    available_moves.each_with_object([]) do |move, moves|
      new_board = board.duplicate

      new_board.move_piece!(location, move)
      moves << move if !new_board.in_check?(color)
    end
  end

  def value
    self.class::VALUE
  end

  def location_value
    row, column = location
    case color
    when :white then self.class::WHITE_LOCATION_VALUE[row][column]
    else self.class::BLACK_LOCATION_VALUE[row][column]
    end
  end

  private

  def current_row
    location.first
  end

  def current_column
    location.last
  end

  def move_directions
    self.class::MOVE_DIRECTIONS
  end

  def enemy_in?(location)
    board.within_limits?(location) && 
      board[location].is_a?(Piece) &&
      board[location].color != color
  end

  def friend_in?(location)
    board[location].is_a?(Piece) && board[location].color == color
  end
end