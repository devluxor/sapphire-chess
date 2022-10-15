require_relative 'pieces.rb'

require 'pry'

class Board
  EMPTY_SQUARE = ' '
  PIECES_SEQUENCE = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ]

  attr_reader :grid
  
  def self.initialize_board
    board = self.new

    8.times do |column|
      board[[1, column]] = Pawn.new(:black)
      board[[6, column]] = Pawn.new(:white)
    end
    
    [[0, :black], [7, :white]].each do |(row, color)|
      PIECES_SEQUENCE.each_with_index do |piece, column|
        board[[row, column]] = piece.new(color)
      end
    end

    board
  end

  def initialize
    @grid = Array.new(8) { Array.new(8, EMPTY_SQUARE)}
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
    rox < grid.size &&
      column < grid.first.size &&
      row >= 0 &&
      column >=0
  end
end


# place pieces
# out of bounds
# get a piece



# Nouns - classes
# Verbs - methods

# messages - methods
# actors - classes
