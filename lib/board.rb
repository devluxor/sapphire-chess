require_relative 'pieces.rb'

require 'pry'

class Board
  EMPTY_SQUARE = ' '
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

    SQUARE_ORDER.times do |column|
      board[[B_PAWN_ROW, column]] = Pawn.new(board, [B_PAWN_ROW, column], :black)
      board[[W_PAWN_ROW, column]] = Pawn.new(board, [W_PAWN_ROW, column], :white)
    end
    
    [[FIRST_ROW, :black], [LAST_ROW, :white]].each do |(row, color)|
      PIECES_SEQUENCE.each_with_index do |piece, column|
        board[[row, column]] = piece.new(board, [row, column], color)
      end
    end

    board
  end

  def initialize
    @grid = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, EMPTY_SQUARE)}
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
    grid[row][column] == EMPTY_SQUARE
  end
end

# Nouns - classes
# Verbs - methods

# messages - methods
# actors - classes
