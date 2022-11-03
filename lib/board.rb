require_relative 'pieces.rb'
require_relative 'board_renderer.rb'

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
    @grid = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, NullPiece.instance)}
    @renderer = BoardRenderer.new(self) # For testing only
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

  def move_piece!(start_position, end_position)
    self[start_position], self[end_position] = NullPiece.instance, self[start_position]

    self[end_position].location = end_position if self[end_position].is_a?(Piece)
  end

  def in_check?(color)
    king_position = find_king(color)
    
    enemy_pieces(color).each do |piece|
      return true if piece.available_moves.include?(king_position)
    end
    
    false
  end

  def find_king(color)
    king_location = pieces.find { |piece| piece.color == color && piece.is_a?(King) }

    king_location ? king_location.location : nil
  end
  
  def checkmate?(color)
    return false unless in_check?(color)

    friendly_pieces(color).all? { |piece| piece.safe_moves.empty? }
  end

  def no_king?(color)
    find_king(color).nil?
  end
  
  # Deep duplication of the board
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

  def pieces
    grid.flatten.reject { |position| position.is_a?(NullPiece) }
  end

  def friendly_pieces(color)
    pieces.select { |piece| piece.color == color }
  end

  def enemy_pieces(color)
    pieces.select { |piece| piece.color != color }
  end

  def count(type, color)
    friendly_pieces(color).select { |piece| piece.class == type }.size
  end

  def promoted_pawns(color)
    friendly_pieces(Pawn).select do |piece| 
      piece.class == Pawn && piece.promoted?
    end.size
  end
end