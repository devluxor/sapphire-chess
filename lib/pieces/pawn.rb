require_relative '../movement_rules/en_passant_piece_control.rb'

class Pawn < Piece
  BLACK = ['♟', '♛']
  WHITE = ['♙', '♕']
  
  B_OPPOSITE_ROW = 7
  W_OPPOSITE_ROW = 0
  
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ]
  
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
  ]

  BLACK_LOCATION_VALUE = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [5, -5, -10, 0, 0, -10, -5, 5],
    [0, 0, 0, 20, 20, 0, 0, 0],
    [5, 5, 10, 25, 25, 10, 5, 5],
    [10, 10, 20, 30, 30, 20, 10, 10],
    [50, 50, 50, 50, 50, 50, 50, 50],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ]

  WHITE_LOCATION_VALUE_EASY = [
    [100, 100, 100, 100, 100, 100, 100, 100],
    [60, 60, 60, 60, 60, 60, 60, 60], 
    [50, 50, 60, 60, 60, 60, 50, 50],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [50, 50, 60, 60, 60, 60, 50, 50],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ]
  
  BLACK_LOCATION_VALUE_EASY = [
    [0, 0, 0, 0, 0, 0, 0, 0], 
    [5, 10, 10, -20, -20, 10, 10, 5], 
    [50, 50, 60, 60, 60, 60, 50, 50], 
    [50, 50, 60, 60, 60, 60, 50, 50], 
    [50, 50, 60, 60, 60, 60, 50, 50], 
    [50, 50, 60, 60, 60, 60, 50, 50], 
    [60, 60, 60, 60, 60, 60, 60, 60], 
    [100, 100, 100, 100, 100, 100, 100, 100]
  ]
  
  include SlidePattern
  include EnPassantPieceControl

  def initialize(board, location, color)
    super(board, location, color)
    @promoted = false
  end

  def to_s
    promote unless promoted?
    
    if promoted?
      case color
      when :white then Paint[self.class::WHITE.last, :white, :bright]
      else Paint[self.class::BLACK.last, :blue, :bright]
      end
    else
      case color
      when :white then Paint[self.class::WHITE.first, :white]
      else Paint[self.class::BLACK.first, :blue]
      end
    end
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

  def available_moves
    if promoted?
      super
    else
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

      # If en passant possible
      add_en_passant(moves)
      
      moves.select { |move| board.within_limits?(move) }
    end
  end

  def promoted?
    @promoted
  end

  private

  attr_writer :promoted

  def promote
    self.promoted = true if location.first == opposite_row
  end

  def opposite_row
    case color
    when :white then W_OPPOSITE_ROW
    else B_OPPOSITE_ROW
    end
  end

  def at_start?
    start_row = (color == :white ? Board::W_PAWN_ROW : Board::B_PAWN_ROW)
 
    current_row == start_row
  end

  def forward_direction
    color == :white ? -1 : 1
  end
end
