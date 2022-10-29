require_relative './lib/board.rb'
require_relative './lib/board_renderer.rb'
require_relative './lib/pieces.rb'
require_relative './lib/player.rb'
require_relative './lib/engine.rb'

require 'pry'

system 'clear'
board = Board.initialize_board

# board = Board.new

# board[[1, 1]] = King.new(board, [1, 1], :black)

# board[[1, 0]] = Rook.new(board, [1, 0], :white)
# board[[0, 1]] = Rook.new(board, [0, 1], :white)
# board[[7, 0]] = Rook.new(board, [7, 0], :white)
# board[[2, 0]] = Bishop.new(board, [2, 0], :white)
# board[[0, 7]] = Rook.new(board, [0, 7], :white)
# board[[2, 3]] = Queen.new(board, [2, 3], :white)

# board[[7, 7]] = King.new(board, [7, 7], :white)

# text_board = BoardRendererText.new(board)
# text_board.render

game = ChessEngine.new
game.play
