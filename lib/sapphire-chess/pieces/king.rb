class King < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [1, 1], [1, 0], [0, -1],
    [1, -1], [-1, 1], [-1, -1], [-1, 0]
  ].freeze

  BLACK = '♚'
  WHITE = '♔'

  VALUE = 20_000

  WHITE_LOCATION_VALUE = [
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-20, -30, -30, -40, -40, -30, -30, -20],
    [-10, -20, -20, -20, -20, -20, -20, -10],
    [20, 20,  0,  0,  0,  0, 20, 20],
    [20, 30, 10,  0,  0, 10, 30, 20]
  ].freeze

  BLACK_LOCATION_VALUE = [
    [20, 30, 10, 0, 0, 10, 30, 20],
    [20, 20, 0, 0, 0, 0, 20, 20],
    [-10, -20, -20, -20, -20, -20, -20, -10],
    [-20, -30, -30, -40, -40, -30, -30, -20],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30]
  ].freeze

  WHITE_LOCATION_VALUE_END = [
    [-50, -40, -30, -20, -20, -30, -40, -50],
    [-30, -20, -10, 0,  0, -10, -20, -30],
    [-30, -10, 20, 30, 30, 20, -10, -30],
    [-30, -10, 30, 40, 40, 30, -10, -30],
    [-30, -10, 30, 40, 40, 30, -10, -30],
    [-30, -10, 20, 30, 30, 20, -10, -30],
    [-30, -30,  0,  0,  0,  0, -30, -30],
    [-50, -30, -30, -30, -30, -30, -30, -50]
  ].freeze

  BLACK_LOCATION_VALUE_END = [
    [-50, -30, -30, -30, -30, -30, -30, -50],
    [-30, -30, 0, 0, 0, 0, -30, -30],
    [-30, -10, 20, 30, 30, 20, -10, -30],
    [-30, -10, 30, 40, 40, 30, -10, -30],
    [-30, -10, 30, 40, 40, 30, -10, -30],
    [-30, -10, 20, 30, 30, 20, -10, -30],
    [-30, -20, -10, 0, 0, -10, -20, -30],
    [-50, -40, -30, -20, -20, -30, -40, -50]
  ].freeze

  include StepPattern
  include CastlingPieceControl

  def initialize(board, location, color)
    super
    @moved = false
  end

  def location_value
    row, column = location

    location_value_table =
      if board.end_game? && color == :white then self.class::WHITE_LOCATION_VALUE_END
      elsif board.end_game? && color == :black then self.class::BLACK_LOCATION_VALUE_END
      elsif !board.end_game? && color == :white then self.class::WHITE_LOCATION_VALUE
      else
        self.class::BLACK_LOCATION_VALUE
      end

    location_value_table[row][column]
  end
end
