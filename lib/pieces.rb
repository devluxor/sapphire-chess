require_relative 'board.rb'
require_relative 'slideable.rb'
require_relative 'stepable.rb'

class Piece
  attr_reader :color, :board, :location

  def initialize(board, location, color)
    @board = board
    @color = color
    @location = location
  end

  # Remove? (not necessary??)
  def allowed_move?(location)
    board[location] == Board::EMPTY_SQUARE || board[location].color != color
  end

  def enemy_in?(location)
    board[location] != Board::EMPTY_SQUARE &&
    board[location].color != color
  end
end

class Pawn < Piece
  include Stepable

  def to_s
    color == :white ? '♙' : '♟'
  end

  def move_directions
    [[0, 1]]
  end
end

class Rook < Piece
  include Slideable

  def to_s
    color == :white ? '♖' : '♜'
  end

  def move_directions
    [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]
  end
end

class Knight < Piece
  def to_s
    color == :white ? '♘' : '♞'
  end

  def move_directions
    [
      [1, 2],
      [2, 1],
      [-1, 2],
      [-2, 1],
      [1, -2],
      [2, -1],
      [-1, -2],
      [-2, -1]
    ]
  end
end

class Bishop < Piece
  include Slideable

  def to_s
    color == :white ? '♗' : '♝'
  end

  def move_directions
    [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
  end
end

class Queen < Piece
  include Slideable

  def to_s
    color == :white ? '♕' : '♛'
  end

  def move_directions
    [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
  end
end

class King < Piece
  include Stepable

  def to_s
    color == :white ? '♔' : '♚'
  end

  def move_directions
    [
      [0, 1],
      [1, 1],
      [1, 0],
      [0, -1],
      [1, -1],
      [-1, 1],
      [-1, -1],
      [-1, 0]
    ]
  end
end



