require_relative 'lib/board.rb'
require_relative 'lib/board_renderer_text.rb'
require_relative 'lib/pieces.rb'

system 'clear'
board = Board.initialize_board

text_board = BoardRendererText.new(board)

text_board.render