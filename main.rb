require_relative './lib/board.rb'
require_relative './lib/board_renderer.rb'
require_relative './lib/pieces.rb'
require_relative './lib/player.rb'
require_relative './lib/engine.rb'

require 'pry'

ChessEngine.new.play
