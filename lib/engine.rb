require_relative 'board/board_general'
require_relative 'board/board_renderer'
require_relative 'pieces'
require_relative 'player'
require_relative 'display'
require_relative 'version'
require_relative 'human_input_validation'
require_relative 'algebraic_conversion'

require 'paint'

class Engine
  include Display
  include HumanInputValidation
  include AlgebraicConversion

  def initialize
    @board = Board.initialize_board
    @renderer = BoardRenderer.new(board)
    @turn_number = 1
  end

  def play
    display_welcome
    define_players
    @current_player = white_player
    board.add_players!(white_player, black_player)
    if computer_plays?
      set_difficulty
      board.set_game_difficulty
    end

    main_game_loop

    end_game
  end

  private

  attr_reader :white_player, :black_player, :board, :renderer
  attr_accessor :current_player, :turn_number

  def define_players
    human_vs_ai = prompt_game_mode == 1
    human_player_color = human_vs_ai ? prompt_color : ''

    @white_player = # Computer.new(:white, board)
    set_player(:white, human_player_color, mode: human_vs_ai)

    @black_player = # Computer.new(:black, board)
    set_player(:black, human_player_color, mode: human_vs_ai)
  end

  def set_player(color, human_player_color, mode: nil)
    if (human_player_color.match?(/w/) && mode) || !mode
      Human.new(color, board)
    else
      Computer.new(color, board)
    end
  end

  def computer_plays?
    white_player.is_a?(Computer) || black_player.is_a?(Computer)
  end

  # See Computer in player.rb, AI#minimax in ai.rb
  def set_difficulty
    difficulty_input = prompt_difficulty

    [white_player, black_player].each do |player|
      player.depth = difficulty_input if player.is_a?(Computer)
    end
  end

  def main_game_loop
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
  end

  def swap_player!
    self.current_player =
      current_player == white_player ? black_player : white_player
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
      current_player.select_move
    end
  end

  def perform_move!(move_input)
    piece, target_square = convert_player_input(move_input)
    store_move!(piece, target_square)

    case piece
    when :castle then board.castle!(target_square, current_player.color, permanent: true)
    else
      board.move_piece!(piece, target_square, permanent: true)
    end
  end

  def store_move!(piece, target_square)
    current_player.history << [piece, target_square]

    current_player.last_move = move_to_string(piece, target_square)
  end

  def move_to_string(piece, target_square)
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
