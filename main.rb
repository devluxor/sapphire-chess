require_relative 'lib/board.rb'
require_relative 'lib/board_renderer_text.rb'
require_relative 'lib/pieces.rb'

system 'clear'
board = Board.new
board[[0, 0]] = King.new(board, [0, 0], :black)
p board[[0, 0]].available_moves

# text_board = BoardRendererText.new(board)

# text_board.render