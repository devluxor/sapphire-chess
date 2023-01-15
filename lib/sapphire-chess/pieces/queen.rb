class Queen < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ].freeze

  BLACK = '♛'
  WHITE = '♕'

  VALUE = 900

  WHITE_LOCATION_VALUE = [
    [-20, -10, -10, -5, -5, -10, -10, -20],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-10, 0, 5, 5, 5, 5, 0, -10],
    [-5, 0, 5, 5, 5, 5, 0, -5],
    [0, 0, 5, 5, 5, 5, 0, -5],
    [-10, 5, 5, 5, 5, 5, 0, -10],
    [-10, 0, 5, 0, 0, 0, 0, -10],
    [-20, -10, -10, -5, -5, -10, -10, -20]
  ].freeze

  BLACK_LOCATION_VALUE = [
    [-20, -10, -10, -5, -5, -10, -10, -20],
    [-10, 0, 0, 0, 0, 5, 0, -10],
    [-10, 0, 5, 5, 5, 5, 5, -10],
    [-5, 0, 5, 5, 5, 5, 0, 0],
    [-5, 0, 5, 5, 5, 5, 0, -5],
    [-10, 0, 5, 5, 5, 5, 0, -10],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-20, -10, -10, -5, -5, -10, -10, -20]
  ].freeze

  include SlidePattern

  def location_value
    row, column = location

    case color
    when :white then self.class::WHITE_LOCATION_VALUE[row][column]
    else self.class::BLACK_LOCATION_VALUE[row][column]
    end
  end
end
