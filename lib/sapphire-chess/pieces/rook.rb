class Rook < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0]
  ].freeze

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
  ].freeze

  BLACK_LOCATION_VALUE = [
    [0, 0, 0, 5, 5, 0, 0, 0],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ].freeze

  WHITE_LOCATION_VALUE_EASY = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [0, 0, 0, 5, 5, 0, 0, 0]
  ].freeze

  BLACK_LOCATION_VALUE_EASY = [
    [0, 0, 0, 5, 5, 0, 0, 0],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [-5, 0, 10, 10, 10, 10, 0, -5],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ].freeze

  include SlidePattern
  include CastlingPieceControl

  def initialize(board, location, color)
    super
    @moved = false
  end
end