require_relative '../movement_rules/en_passant_piece_control'
require_relative '../movement_rules/pawn_movement_and_promotion'

class Pawn < Piece
  BLACK = ['♟', '♛'].freeze
  WHITE = ['♙', '♕'].freeze

  B_OPPOSITE_ROW = 7
  W_OPPOSITE_ROW = 0

  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ].freeze

  VALUE = 100

  WHITE_LOCATION_VALUE = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [50, 50, 50, 50, 50, 50, 50, 50],
    [10, 10, 20, 30, 30, 20, 10, 10],
    [5, 5, 10, 25, 25, 10, 5, 5],
    [0, 0, 0, 20, 20, 0, 0, 0],
    [5, -5, -10, 0, 0, -10, -5, 5],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ].freeze

  BLACK_LOCATION_VALUE = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [5, -5, -10, 0, 0, -10, -5, 5],
    [0, 0, 0, 20, 20, 0, 0, 0],
    [5, 5, 10, 25, 25, 10, 5, 5],
    [10, 10, 20, 30, 30, 20, 10, 10],
    [50, 50, 50, 50, 50, 50, 50, 50],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ].freeze

  WHITE_LOCATION_VALUE_EASY = [
    [100, 100, 100, 100, 100, 100, 100, 100],
    [60, 60, 60, 60, 60, 60, 60, 60],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [50, 50, 60, 0, 0, 60, 50, 50],
    [50, 50, 10, 0, 0, 10, 50, 50],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ].freeze

  BLACK_LOCATION_VALUE_EASY = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [50, 50, 10, 0, 0, 10, 50, 50],
    [50, 50, 60, 0, 0, 60, 50, 50],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [60, 60, 60, 60, 60, 60, 60, 60],
    [100, 100, 100, 100, 100, 100, 100, 100]
  ].freeze

  include SlidePattern
  include EnPassantPieceControl
  include PawnMovementAndPromotion

  def initialize(board, location, color)
    super(board, location, color)
    @promoted = false
  end

  def to_s
    promote unless promoted?

    white = color == :white
    if promoted? && white then Paint[self.class::WHITE.last, :white, :bright]
    elsif promoted? && !white then Paint[self.class::BLACK.last, :blue, :bright]
    elsif !promoted? && white then Paint[self.class::WHITE.first, :white]
    else
      Paint[self.class::BLACK.first, :blue]
    end
  end
end
