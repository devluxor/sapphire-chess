require_relative 'lib/board.rb'
require_relative 'lib/board_renderer_text.rb'
require_relative 'lib/pieces.rb'
require_relative 'lib/player.rb'
require_relative 'lib/game.rb'

require 'pry'

system 'clear'
board = Board.initialize_board

# board = Board.new

# board[[0, 1]] = Knight.new(board, [0, 1], :white)

text_board = BoardRendererText.new(board)
text_board.render

game = Game.new(board, Player.new(:white), Player.new(:black), BoardRendererText)
game.play
