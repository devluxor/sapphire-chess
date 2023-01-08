require_relative 'board/board_general.rb'
require_relative 'board/board_renderer.rb'
require_relative 'pieces.rb'
require_relative 'player.rb'
require_relative 'display.rb'
require_relative 'human_move_validation.rb'
require_relative 'algebraic_conversion.rb'

require 'paint'

class Engine
  include Display
  include HumanMoveValidation
  include AlgebraicConversion

  def initialize
    @board = Board.initialize_board
    @renderer = BoardRenderer.new(board)
    @turn_number = 1
  end
  
  def play
    display_welcome
    set_players
    @current_player = white_player
    set_difficulty if computer_plays?
    board.add_players!(white_player, black_player)

    until game_over?
      clear_screen
      renderer.render
      display_graphic_score
      display_last_moves
      display_turn_number
      display_player_turn
      perform_move!(player_move_selection)
      swap_player!
      update_turn_counter
    end

    end_game
  end
  
  private

  attr_reader :white_player, :black_player, :board, :renderer
  attr_accessor :current_player, :turn_number

  def set_players
    color_choice = prompt_color
    
    @white_player = 
    if color_choice.match?(/w/) then Human.new(:white, board)
    else Computer.new(:white, board)
    end

    @black_player =
    if white_player.is_a?(Human) then Computer.new(:black, board)
    else Human.new(:black, board)
    end
  end

  def computer_plays?
    white_player.is_a?(Computer) || black_player.is_a?(Computer)
  end

  # See Computer#initialize in player.rb, AI#minimax in ai.rb
  def set_difficulty
    difficulty_input = prompt_difficulty

    [white_player, black_player].each do |player|
      if player.is_a?(Computer)
        player.depth =
        if difficulty_input == 'easy' || difficulty_input == '1' then 1
        elsif difficulty_input == 'medium' || difficulty_input == '2' then 2
        else 3
        end
      end
    end
  end
  
  def swap_player!
    self.current_player = (
      current_player == white_player ? black_player : white_player
    )
  end

  def update_turn_counter
    self.turn_number += 0.5
  end

  def player_move_selection
    if current_player.is_a?(Human)
      display_check if board.in_check?(current_player.color)
      prompt_move
    else
      puts "\n🤖 I am thinking... 🤖"
      current_player.get_move
    end
  end  
  
  def perform_move!(move_input)
    piece, target_square = convert_player_input(move_input)
    store_move!(piece, target_square)

    case piece
    when :castle then board.castle!(target_square, current_player.color, true)
    else board.move_piece!(piece, target_square, true)
    end
  end

  def store_move!(piece, target_square)
    current_player.history << [piece, target_square]

    current_player.last_move = 
    if piece == :castle
      "Castle, #{target_square} side"
    elsif board[target_square].is_a?(Piece)
      "#{board[piece].class} #{convert_to_algebraic(piece)} "\
      "to #{board[target_square].class} "\
      "#{convert_to_algebraic(target_square)}"
    else
      "#{board[piece].class} #{convert_to_algebraic(piece)} "\
      "to #{convert_to_algebraic(target_square)}"
    end
  end

  def end_game
    clear_screen
    renderer.render
    swap_player!
    display_winner
  end

  def game_over?
    board.checkmate?(current_player.color) || board.no_king?(current_player.color)
  end
end
