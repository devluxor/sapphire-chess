require_relative 'lib/board.rb'
require_relative 'lib/board_renderer_text.rb'
require_relative 'lib/pieces.rb'
require_relative 'lib/player.rb'
require_relative 'lib/game.rb'

require 'pry'

system 'clear'
board = Board.initialize_board

# text_board = BoardRendererText.new(board)


# binding.pry
# board[[2, 2]] = Pawn.new(board, [2, 2], :white)
# board[[2, 0]] = Pawn.new(board, [2, 0], :white)


# text_board.render

game = Game.new(board, Player.new(:white), Player.new(:black), BoardRendererText)
game.play