require_relative 'lib/board.rb'
require_relative 'lib/board_renderer_text.rb'
require_relative 'lib/pieces.rb'
require_relative 'lib/player.rb'
require_relative 'lib/game.rb'

require 'pry'

system 'clear'
# board = Board.initialize_board
board = Board.new

board[[0, 0]] = King.new(board, [0, 0], :black)
board[[6, 6]] = King.new(board, [6, 6], :white)

board[[2, 0]] = Rook.new(board, [2, 0], :white)
board[[0, 3]] = Rook.new(board, [0, 3], :white)

board[[2, 2]] = Queen.new(board, [2, 2], :white)

text_board = BoardRendererText.new(board)
text_board.render

puts "black king in in_check?: #{board.in_check?(:black)}"
puts "white king in in_check?: #{board.in_check?(:white)}"

puts "black king in checkmate?: #{board.checkmate?(:black)}"
puts "white king in checkmate?: #{board.checkmate?(:white)}"






# puts "black king in check?" + board.in_check?(:black).to_s
# puts "white king in check?" + board.in_check?(:white).to_s





# binding.pry
# board[[2, 2]] = Pawn.new(board, [2, 2], :white)
# board[[2, 0]] = Pawn.new(board, [2, 0], :white)



# game = Game.new(board, Player.new(:white), Player.new(:black), BoardRendererText)
# game.play
