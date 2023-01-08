class Rook < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0]
  ]

  BLACK = '♜'
  WHITE = '♖'
  
  VALUE = 500

  WHITE_LOCATION_VALUE = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [0, 0, 0, 5, 5, 0, 0, 0]
  ]

  BLACK_LOCATION_VALUE = [
    [0, 0, 0, 5, 5, 0, 0, 0],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ]

  WHITE_LOCATION_VALUE_EASY = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [0, 0, 0, 5, 5, 0, 0, 0]
  ]

  BLACK_LOCATION_VALUE_EASY = [
    [0, 0, 0, 5, 5, 0, 0, 0],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ]

  include SlidePattern
  include CastlingPieceControl

  def initialize(board, location, color)
    super
    @moved = false
  end

  def location_value
    row, column = location
    if board.hard_difficulty
      case color
      when :white then self.class::WHITE_LOCATION_VALUE[row][column]
      else self.class::BLACK_LOCATION_VALUE[row][column]
      end
    else
      case color
      when :white then self.class::WHITE_LOCATION_VALUE_EASY[row][column]
      else self.class::BLACK_LOCATION_VALUE_EASY[row][column]
      end
    end
  end
end
