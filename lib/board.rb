require_relative 'pieces.rb'

require 'pry'

class Board
  # EMPTY_SQUARE = ' '
  SQUARE_ORDER = 8
  B_PAWN_ROW = 1
  W_PAWN_ROW = 6
  FIRST_ROW = 0
  LAST_ROW = 7
  PIECES_SEQUENCE = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ]

  attr_reader :grid
  
  def self.initialize_board
    board = self.new

    # initializes pawns
    SQUARE_ORDER.times do |column|
      board[[B_PAWN_ROW, column]] = Pawn.new(board, [B_PAWN_ROW, column], :black)
      board[[W_PAWN_ROW, column]] = Pawn.new(board, [W_PAWN_ROW, column], :white)
    end
    
    # initializes rest of pieces
    [[FIRST_ROW, :black], [LAST_ROW, :white]].each do |(row, color)|
      PIECES_SEQUENCE.each_with_index do |piece, column|
        board[[row, column]] = piece.new(board, [row, column], color)
      end
    end

    board
  end

  def initialize
    @grid = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, NullPiece.instance)}
  end

  def []=(location, piece)
    row, column = location
    grid[row][column] = piece
  end

  def [](location)
    row, column = location
    grid[row][column]
  end

  def in_bounds?(location)
    row, column = location
    row < grid.size &&
      column < grid.first.size &&
      row >= 0 &&
      column >=0
  end

  def empty_square?(location)
    row, column = location
    grid[row][column].is_a?(NullPiece)
  end

  # RENAME
  def move_piece(start_position, end_position)
    piece = self[start_position]

    if !piece.available_moves.include?(end_position)
      raise "Unavailable end position #{end_position}."
    elsif !in_bounds?(end_position)
      raise 'End position not in bounds.'
    end

    move_piece!(start_position, end_position)
  end

  def move_piece!(start_position, end_position)
    self[start_position], self[end_position] = NullPiece.instance, self[start_position]

    self[end_position].location = end_position
  end

  def in_check?(color)
    king_position = find_king(color)

    pieces.select { |piece| piece.color != color }.each do |piece|
      return true if piece.available_moves.include?(king_position)
    end
    
    false
  end

  def find_king(color)
    king_location = pieces.find { |piece| piece.color == color && piece.is_a?(King) }

    king_location ? king_location.location : nil # raise("There is no #{color} king on the board!")
  end

  def pieces
    grid.flatten.reject { |position| position.is_a?(NullPiece) }
  end

  def checkmate?(color)
    return false unless in_check?(color)

    friendly_pieces = pieces.select { |piece| piece.color == color }

    friendly_pieces.all? { |piece| piece.safe_moves.empty? }
  end

  # Deep duplication of the board
  def dup
    pieces.each_with_object(Board.new) do |piece, new_board|
      new_piece = piece.class.new(new_board, piece.location, piece.color)

      new_board[new_piece.location] = new_piece
    end
  end
end