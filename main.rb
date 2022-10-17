require_relative 'lib/board.rb'
require_relative 'lib/board_renderer_text.rb'
require_relative 'lib/pieces.rb'
require 'pry'

system 'clear'
board = Board.initialize_board

text_board = BoardRendererText.new(board)


# binding.pry
board[[2, 2]] = Pawn.new(board, [2, 2], :white)
board[[2, 0]] = Pawn.new(board, [2, 0], :white)

p board[[2, 2]].available_moves
board.move_piece([1, 1], [3, 1])
text_board.render