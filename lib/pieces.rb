require 'singleton'
require 'paint'

require_relative 'board.rb'
require_relative 'movement.rb'

require 'pry'

class NullPiece
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
    board.in_bounds?(location) &&
      !board[location].is_a?(NullPiece) &&
      board[location].color != color
  end
end

class Pawn < Piece
  include Stepable

  BLACK = '♟'
  WHITE = '♙'

  def available_moves
    moves = []
    current_row, current_column = location

    one_forward = [current_row + forward_direction, current_column]
    moves << one_forward if board.empty_square?(one_forward)

    # If at start line, move forward 2
    two_forward = [current_row + (forward_direction * 2), current_column]
    if board.empty_square?(two_forward) && 
      board.empty_square?(one_forward) &&
      at_start?
      moves << two_forward
    end

    # If enemy on diagonal
    diagonal_left = [current_row + forward_direction, current_column + 1]
    diagonal_right = [current_row + forward_direction, current_column - 1]
    moves << diagonal_left if enemy_in?(diagonal_left)
    moves << diagonal_right if enemy_in?(diagonal_right)

    moves.select { |move| board.in_bounds?(move) }
  end

  private

  def at_start?
    start_row = (color == :white ? Board::W_PAWN_ROW : Board::B_PAWN_ROW)
 
    current_row == start_row
  end

  def forward_direction
    color == :white ? -1 : 1
  end
end

class Rook < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0]
  ]

  BLACK = '♜'
  WHITE = '♖'

  include Slideable
end

class Knight < Piece
  MOVE_DIRECTIONS = [
    [1, 2], [2, 1], [-1, 2], [-2, 1],
    [1, -2], [2, -1], [-1, -2], [-2, -1]
  ]

  BLACK = '♞'
  WHITE = '♘'

  include Stepable
end

class Bishop < Piece
  MOVE_DIRECTIONS = [
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ]

  BLACK = '♝'
  WHITE = '♗'

  include Slideable
end

class Queen < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ]

  BLACK = '♛'
  WHITE = '♕'
    
  include Slideable
end

class King < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [1, 1], [1, 0], [0, -1],
    [1, -1], [-1, 1], [-1, -1], [-1, 0]
  ]

  BLACK = '♚'
  WHITE = '♔'

  include Stepable
end
