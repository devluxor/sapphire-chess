require_relative 'pieces.rb'
require_relative 'board_renderer.rb'
require_relative 'board_analysis.rb'

require 'pry'

class Board
  SQUARE_ORDER = 8
  B_PAWN_ROW = 1
  W_PAWN_ROW = 6
  FIRST_ROW = 0
  LAST_ROW = 7
  PIECES_SEQUENCE = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ]

  include BoardAnalysis
  include Evaluation

  attr_reader :grid, :renderer
  
  def self.initialize_board
    board = self.new

    [B_PAWN_ROW, W_PAWN_ROW].each do |pawn_row|
      color = pawn_row == B_PAWN_ROW ? :black : :white

      SQUARE_ORDER.times do |column|
        board[[pawn_row, column]] = Pawn.new(board, [pawn_row, column], color)
      end
    end

    [[FIRST_ROW, :black], [LAST_ROW, :white]].each do |(row, color)|
      PIECES_SEQUENCE.each_with_index do |piece, column|
        board[[row, column]] = piece.new(board, [row, column], color)
      end
    end
    
    board
  end
  
  def initialize
    @grid = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, NullPiece.instance) }
  end

  def [](location)
    row, column = location
    grid[row][column]
  end

  def []=(location, piece)
    row, column = location
    grid[row][column] = piece
  end

  def in_bounds?(location)
    location.none? { |axis| axis >= SQUARE_ORDER || axis < 0 }
  end

  def empty_square?(location)
    row, column = location
    in_bounds?(location) && grid[row][column].is_a?(NullPiece)
  end

  def move_piece!(start_position, end_position, color=nil)   
    self[start_position], self[end_position] = NullPiece.instance, self[start_position]

    self[end_position].location = end_position if self[end_position].is_a?(Piece)
  end

  def castle!(side, color)
    case color
    when :white
      if side == :king
        move_piece!([7,4], [7,6])
        move_piece!([7,7], [7,5])
      else
        move_piece!([7,4], [7,2])
        move_piece!([7,0], [7,3])
      end
    when :black
      if side == :king
        move_piece!([0,4], [0,6])
        move_piece!([0,7], [0,5])
      else
        move_piece!([0,4], [0,2])
        move_piece!([0,0], [0,3])
      end
    end
  end

  def uncastle!(side, color)
    case color
    when :white
      if side == :king
        move_piece!([7,6], [7,4])
        move_piece!([7,5], [7,7])
      else
        move_piece!([7,2], [7,4])
        move_piece!([7,3], [7,0])
      end
    when :black
      if side == :king
        move_piece!([0,6], [0,4])
        move_piece!([0,5], [0,7])
      else
        move_piece!([0,2], [0,4])
        move_piece!([0,3], [0,0])
      end
    end
  end
  
  # Deep duplication of the board for Piece#safe_moves
  def duplicate
    pieces.each_with_object(Board.new) do |piece, new_board|
      new_piece = piece.class.new(new_board, piece.location, piece.color)
      
      new_board[new_piece.location] = new_piece
    end
  end

  def generate_moves(color)
    friendly_pieces(color).each_with_object([]) do |piece, possible_moves|
      location = piece.location

      piece.available_moves.each do |possible_move|
        possible_moves << [location, possible_move]
      end
    end
  end
end