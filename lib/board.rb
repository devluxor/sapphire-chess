require_relative 'pieces.rb'

require 'pry'

class Board
  EMPTY_SQUARE = ' '
  # PIECES_INITIALIZATOR = {
  #   0 => R
  #   7 => 
  #   1 => 
  #   6 => 
  #   2 => 
  #   5 => 
  #   4 => 
  #   3 => 
  # }

  attr_reader :grid
  
  # TODO: Refactor 
  def self.initialize_board
    board = self.new

    8.times do |column|
      board[[1, column]] = Pawn.new(:black)
      board[[6, column]] = Pawn.new(:white)
    end

    [[0, :black], [7, :white]].each do |(row, color)|
      board[[row, 0]] = Rook.new(color)
      board[[row, 7]] = Rook.new(color)
      board[[row, 1]] = Knight.new(color)
      board[[row, 6]] = Knight.new(color)    
      board[[row, 2]] = Bishop.new(color)
      board[[row, 5]] = Bishop.new(color)
      board[[row, 4]] = King.new(:black)
      board[[row, 3]] = Queen.new(:black)
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
