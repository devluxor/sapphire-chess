require_relative 'board/board_general.rb'
require_relative 'board/board_renderer.rb'
require_relative 'pieces.rb'
require_relative 'player.rb'
require_relative 'display.rb'
require_relative 'human_move_validation.rb'

require 'paint'
require 'pry'

class ChessEngine
  include Display
  include HumanMoveValidation

  def initialize
    @board = Board.initialize_board
    @renderer = BoardRenderer.new(board)
    @white_player = Human.new(:white, board)
    @black_player = Computer.new(:black, board)
    @current_player = white_player
    @turn_number = 1
  end
  
  def play
    until game_over?
      system 'clear'
      renderer.render
      display_graphic_score
      display_turn_number
      display_player_turn
      perform_move!(player_move_choice)
      swap_player!
      update_turn_counter
    end

    end_game
  end
  
  private

  attr_reader :white_player, :black_player, :board, :renderer
  attr_accessor :current_player, :turn_number
  
  def swap_player!
    self.current_player = (
      current_player == white_player ? black_player : white_player
    )
  end

  def update_turn_counter
    self.turn_number += 0.5
  end

  def player_move_choice
    if current_player.color == :white
      display_check if board.in_check?(current_player.color)
      prompt_move
    else
      puts "\n🤖 I am thinking... 🤖"
      current_player.get_move
    end
  end  
  
  def perform_move!(move_input)
    piece, target_square = convert_player_input(move_input)
    
    case piece
    when :castle then board.castle!(target_square, current_player.color, true)
    else board.move_piece!(piece, target_square, true)
    end
  end

  def end_game
    system 'clear'
    renderer.render
    swap_player!
    display_winner
  end

  def game_over?
    board.checkmate?(current_player.color) || board.no_king?(current_player.color)
  end
end
