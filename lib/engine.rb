require_relative 'board.rb'
require_relative 'pieces.rb'
require_relative 'board_renderer.rb'
require_relative 'player.rb'
require_relative 'display.rb'

require 'paint'

require 'pry'

class ChessEngine
  include Display

  def initialize
    @board = Board.initialize_board
    @renderer = BoardRenderer.new(board)
    @white_player = Human.new(:white, board)
    @black_player = Computer.new(:black, board)
    @current_player = white_player
  end
  
  def play
    loop do
      system 'clear'
      renderer.render
      turn!
      swap_player!
      break if game_over?
    end

    end_game
  end
  
  private

  attr_reader :white_player, :black_player, :board, :renderer
  attr_accessor :current_player
  
  def swap_player!
    self.current_player = (
      current_player == white_player ? black_player : white_player
    )
  end

  def end_game
    system 'clear'
    renderer.render
    swap_player!
    puts Paint['Checkmate!', nil, :red, :bright]
    puts ''
    display_winner
    puts 'End'
  end

  def turn!
    display_graphic_score
    display_player_turn

    player_move_input = if current_player.color == :white
                          display_check if board.in_check?(current_player.color)
                          prompt_move_position
                        else
                          puts "\n🤖 I am thinking... 🤖"
                          current_player.get_position
                        end

    perform_move!(player_move_input)
  end

  def convert_player_input(player_move_input)
    if single_input?(player_move_input)
      start_position = player_move_input
      target_position = prompt_target_position(start_position)
    else
      start_position = player_move_input.first
      target_position = player_move_input.last
    end

    [start_position, target_position]
  end

  def double_input?(player_move_input)
    player_move_input.first.is_a?(Array)
  end

  def single_input?(player_move_input)
    player_move_input.first.is_a?(Integer)
  end

  def prompt_move_position
    puts 'What piece do you want to move?'
    puts '[Use algebraic notation, i.e.: "a2a4"]'
    puts '[To castle, "castle (k for king side, q for queen side), i.e: "castle k"]'

    player_move_input = nil
    loop do
      player_move_input = current_player.get_position
      break if valid_player_input?(player_move_input)
      puts "Please, select a valid movement." # Change?
    end

    player_move_input
  end
  
  def prompt_target_position(start_position)
    target_position = nil
    puts "Where do you want to move the #{board[start_position].class}?"
    loop do
      target_position = current_player.get_position
      break if valid_target_position?(start_position, target_position)
      puts "The #{board[start_position].class} selected can't move to that square."
    end

    end_position
  end

  def valid_player_input?(player_move_input)
    if double_input?(player_move_input)
      valid_piece_selection?(player_move_input.first) &&
      valid_target_position?(player_move_input.first, player_move_input.last)
    elsif player_move_input.first == :castle
      valid_castling?(player_move_input.last)
    else
      valid_piece_selection?(player_move_input)
    end
  end

  def valid_piece_selection?(start_position)
    !board[start_position].is_a?(NullPiece) && 
      board[start_position].color == current_player.color
  end

  def valid_target_position?(start_position, target_position)
    board[start_position].available_moves.include?(target_position)
  end

  def valid_castling?(side)
    current_player.castle_rights?(side)
  end

  def perform_move!(move_input)
    start_position, target_position = convert_player_input(move_input)
    
    case start_position
    when :castle then board.castle!(target_position, current_player.color)
    else board.move_piece!(start_position, target_position)
    end
  end

  def game_over?
    board.no_king?(current_player.color) || board.checkmate?(current_player.color)
  end
end