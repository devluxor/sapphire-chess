require_relative 'board.rb'
require_relative 'board_renderer.rb'
require 'pry'

class ChessEngine
  attr_reader :player_1, :player_2, :board, :renderer
  attr_accessor :current_player

  # TODO:
  # change game logic

  def initialize(board, white_player, black_player)
    @board = board
    @renderer = BoardRenderer.new(board)
    @white_player = white_player
    @black_player = black_player
    @current_player = white_player
  end
  
  def play
    loop do
      system 'clear'
      renderer.render
      break if game_over?
      
      turn
      
      swap_player!
    end
    
    swap_player!
    puts "#{current_player.color.to_s.capitalize} player wins!"
    puts 'End'
  end

  private

  def swap_player!
    self.current_player = (
      current_player == white_player ? black_player : white_player
    )
  end

  def turn
    puts "It's #{current_player.color}'s turn!"
    puts 'You are in check!' if board.in_check?(current_player.color)

    start_position = nil
    end_position = nil

    loop do
      puts "What piece do you want to move?"
      start_position = current_player.get_position
      break if !board[start_position].is_a?(NullPiece) && 
        board[start_position].color == current_player.color 
      puts "Please, select a #{current_player.color} piece."
    end
    
    loop do
      puts "Where do you want to move the #{board[start_position].class}?"
      end_position = current_player.get_position
      break if board[start_position].available_moves.include?(end_position)
      puts "The #{board[start_position].class} selected can't move to that square."
    end

    board.move_piece!(start_position, end_position)
  end

  def game_over?
    board.checkmate?(current_player.color)
  end
end