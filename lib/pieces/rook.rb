class Rook < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0]
  ]

  A_WHITE_START_LOCATION = [7, 0]
  H_WHITE_START_LOCATION = [7, 7]
  A_BLACK_START_LOCATION = [0, 0]
  H_BLACK_START_LOCATION = [0, 7]

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

  include Slideable

  attr_reader :rook_a_w, :rook_h_w, :rook_a_b, :rook_h_b

  def initialize(board, location, color)
    super(board, location, color)
    @moved = false
    @rook_a_w = true if location == A_WHITE_START_LOCATION
    @rook_h_w = true if location == H_WHITE_START_LOCATION
    @rook_a_b = true if location == A_BLACK_START_LOCATION
    @rook_h_b = true if location == H_BLACK_START_LOCATION
  end

  def moved?
    @moved
  end

  def move
    @moved = case color
             when :white
               true if rook_a_w && location != A_WHITE_START_LOCATION
               true if rook_h_w && location != H_WHITE_START_LOCATION
             else
               true if rook_a_b && location != A_BLACK_START_LOCATION
               true if rook_h_b && location != H_BLACK_START_LOCATION
             end
  end
end
