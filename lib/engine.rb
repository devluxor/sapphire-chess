require_relative 'board.rb'
require_relative 'board_renderer.rb'
require_relative 'player.rb'

require 'paint'

require 'pry'

class ChessEngine 
  def initialize
    @board = Board.initialize_board
    @renderer = BoardRenderer.new(board)
    @white_player = Player.new(:white)
    @black_player = Player.new(:black)
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

    puts "#{current_player.color.to_s.capitalize} player wins!"
    puts 'End'
  end
  
  private

  attr_reader :white_player, :black_player, :board, :renderer
  attr_accessor :current_player
  
  def swap_player!
    self.current_player = (
      current_player == white_player ? black_player : white_player
    )
  end

  def turn!
    puts Paint[
      "It's #{current_player.color}'s turn!", 
      nil, 
      current_player.color, 
      :bright
    ]
    puts 'You are in check!' if board.in_check?(current_player.color)

    player_move_input = prompt_move_position

    if double_input?(player_move_input)
      start_position = player_move_input.first
      end_position = player_move_input.last
    else
      start_position = player_move_input
      end_position = prompt_end_position(start_position)
    end
    
    board.move_piece!(start_position, end_position)
  end

  def double_input?(player_move_input)
    player_move_input.first.is_a?(Array)
  end

  def prompt_move_position
    player_move_input = nil
    puts 'What piece do you want to move?'
    puts '[Format: "start position end position". I.e.: a2a4 ]'
    loop do
      player_move_input = current_player.get_position
      # now start_position can be:
      # -    [row, column]
      # -    [[row, column], [row_end, column_end]]
      break if valid_player_input?(player_move_input)
      # puts "Please, select a #{current_player.color} piece." # Change
      puts "Please, select a valid movement." # Change
    end

    player_move_input
  end

  def valid_player_input?(player_move_input)
    if double_input?(player_move_input)
      valid_piece_selection?(player_move_input.first) &&
      valid_end_position?(player_move_input.first, player_move_input.last)
    else
      valid_piece_selection?(player_move_input)
    end
  end

  def valid_piece_selection?(start_position)
    !board[start_position].is_a?(NullPiece) && 
      board[start_position].color == current_player.color
  end

  def prompt_end_position(start_position)
    end_position = nil
    puts "Where do you want to move the #{board[start_position].class}?"
    loop do
      end_position = current_player.get_position
      break if valid_end_position?(start_position, end_position)
      puts "The #{board[start_position].class} selected can't move to that square."
    end

    end_position
  end

  def valid_end_position?(start_position, end_position)
    board[start_position].available_moves.include?(end_position)
  end

  def game_over?
    board.checkmate?(current_player.color)
  end
end