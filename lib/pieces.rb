require_relative 'board.rb'
require_relative 'movement.rb'
require_relative 'evaluation.rb'

require 'singleton'
require 'paint'

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
    board.in_bounds?(location) &&
      !board[location].is_a?(NullPiece) &&
      board[location].color != color
  end

  def friend_in?(location)
    !board[location].is_a?(NullPiece) && board[location].color == color
  end
end

class Pawn < Piece
  BLACK = ['♟', '♛']
  WHITE = ['♙', '♕']
  
  B_OPPOSITE_ROW = 7
  W_OPPOSITE_ROW = 1
  
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
  
  include Slideable

  def initialize(board, location, color)
    super(board, location, color)
    @promoted = false
  end

  def to_s
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

  def available_moves
    promote unless promoted?

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

      moves.select { |move| board.in_bounds?(move) }
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

class Knight < Piece
  MOVE_DIRECTIONS = [
    [1, 2], [2, 1], [-1, 2], [-2, 1],
    [1, -2], [2, -1], [-1, -2], [-2, -1]
  ]
  
  BLACK = '♞'
  WHITE = '♘'
  
  VALUE = 320

  WHITE_LOCATION_VALUE = [
    [-50, -40, -30, -30, -30, -30, -40, -50],
    [-40, -20, 0, 0, 0, 0, -20, -40],
    [-30, 0, 10, 15, 15, 10, 0, -30],
    [-30, 5, 15, 20, 20, 15, 5, -30],
    [-30, 0, 15, 20, 20, 15, 0, -30],
    [-30, 5, 10, 15, 15, 10, 5, -30],
    [-40, -20, 0, 5, 5, 0, -20, -40],
    [-50, -40, -30, -30, -30, -30, -40, -50]
  ]

  BLACK_LOCATION_VALUE = [
    [-50, -40, -30, -30, -30, -30, -40, -50],
    [-40, -20, 0, 5, 5, 0, -20, -40],
    [-30, 5, 10, 15, 15, 10, 5, -30],
    [-30, 0, 15, 20, 20, 15, 0, -30],
    [-30, 5, 15, 20, 20, 15, 5, -30],
    [-30, 0, 10, 15, 15, 10, 0, -30],
    [-40, -20, 0, 0, 0, 0, -20, -40],
    [-50, -40, -30, -30, -30, -30, -40, -50]
  ]
  
  
  include Stepable
end

class Bishop < Piece
  MOVE_DIRECTIONS = [
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ]
  
  BLACK = '♝'
  WHITE = '♗'
  
  VALUE = 330

  WHITE_LOCATION_VALUE = [
    [-20, -10, -10, -10, -10, -10, -10, -20],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-10, 0, 5, 10, 10, 5, 0, -10],
    [-10, 5, 5, 10, 10, 5, 5, -10],
    [-10, 0, 10, 10, 10, 10, 0, -10],
    [-10, 10, 10, 10, 10, 10, 10, -10],
    [-10, 5, 0, 0, 0, 0, 5, -10],
    [-20, -10, -10, -10, -10, -10, -10, -20]
  ]

  BLACK_LOCATION_VALUE = [
    [-20, -10, -10, -10, -10, -10, -10, -20],
    [-10, 5, 0, 0, 0, 0, 5, -10],
    [-10, 10, 10, 10, 10, 10, 10, -10],
    [-10, 0, 10, 10, 10, 10, 0, -10],
    [-10, 5, 5, 10, 10, 5, 5, -10],
    [-10, 0, 5, 10, 10, 5, 0, -10],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-20, -10, -10, -10, -10, -10, -10, -20]
  ]
  
  include Slideable
end

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
    case color
    when :white
      @moved = true if rook_a_w && location != A_WHITE_START_LOCATION
      @moved = true if rook_h_w && location != H_WHITE_START_LOCATION
    else
      @moved = true if rook_a_b && location != A_BLACK_START_LOCATION
      @moved = true if rook_h_b && location != H_BLACK_START_LOCATION
    end
  end
end

class Queen < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ]
  
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
  ]

  BLACK_LOCATION_VALUE = [
    [-20, -10, -10, -5, -5, -10, -10, -20],
    [-10, 0, 0, 0, 0, 5, 0, -10],
    [-10, 0, 5, 5, 5, 5, 5, -10],
    [-5, 0, 5, 5, 5, 5, 0, 0],
    [-5, 0, 5, 5, 5, 5, 0, -5],
    [-10, 0, 5, 5, 5, 5, 0, -10],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-20, -10, -10, -5, -5, -10, -10, -20]
  ]
    
  include Slideable
end

class King < Piece
  MOVE_DIRECTIONS = [
    [0, 1], [1, 1], [1, 0], [0, -1],
    [1, -1], [-1, 1], [-1, -1], [-1, 0]
  ]

  WHITE_START_LOCATION = [7, 4]
  BLACK_START_LOCATION = [0, 5]
  
  BLACK = '♚'
  WHITE = '♔'

  VALUE = 20000

  WHITE_LOCATION_VALUE = [
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-20,-30,-30,-40,-40,-30,-30,-20],
    [-10,-20,-20,-20,-20,-20,-20,-10],
    [20, 20,  0,  0,  0,  0, 20, 20],
    [20, 30, 10,  0,  0, 10, 30, 20]
  ]

  BLACK_LOCATION_VALUE = [
    [20, 30, 10, 0, 0, 10, 30, 20],
    [20, 20, 0, 0, 0, 0, 20, 20],
    [-10, -20, -20, -20, -20, -20, -20, -10],
    [-20, -30, -30, -40, -40, -30, -30, -20],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30]
  ]

  include Stepable

  def initialize(board, location, color)
    super
    @moved = false
  end

  def moved?
    @moved
  end

  def move
    case color
    when :white then @moved = true if location != WHITE_START_LOCATION
    else @moved = true if location != BLACK_START_LOCATION
    end
  end
end
