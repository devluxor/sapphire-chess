require_relative 'board.rb'
require_relative 'pieces.rb'
require_relative 'board_renderer.rb'
require_relative 'player.rb'

require 'paint'

require 'pry'

class ChessEngine 
  def initialize
    @board = Board.initialize_board

    # @board = Board.new

    # board[[1, 4]] = Pawn.new(board, [1, 4], :white)
    # board[[5, 4]] = Pawn.new(board, [5, 4], :black)

    # board[[0, 0]] = King.new(board, [0, 0], :black)
    # board[[7, 7]] = King.new(board, [7, 7], :white)

    @renderer = BoardRenderer.new(board)
    @white_player = Human.new(:white)
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
    puts Paint[
      "#{current_player.color.to_s.capitalize} player wins!",
      nil, 
      current_player.color
    ]
    puts 'End'
  end

  def turn!
    display_graphic_score

    puts Paint[
      "It's #{current_player.color}'s turn!",
      nil,
      current_player.color,
      :bright
    ]

    player_move_input = if current_player.color == :white
                          puts Paint[
                            'You are in check!', 
                            :red, :bright
                            ] if board.in_check?(current_player.color)

                          prompt_move_position
                        else
                          puts ''
                          puts "🤖 I am thinking... 🤖"
                          current_player.get_position
                        end

    if double_input?(player_move_input)
      start_position = player_move_input.first
      end_position = player_move_input.last
    else
      start_position = player_move_input
      end_position = prompt_end_position(start_position)
    end
    
    board.move_piece!(start_position, end_position)
  end

  def display_graphic_score
    # show each piece icon x number + total material score for each player
    [:black, :white].each do |color|
      message = case color 
                when :black then Paint["Black score", :blue, :underline]
                else Paint["White score", :white, :underline]
                end
      print message + ": "
      display_pieces_score(color)
      puts "\n\n"
    end
  end

  def display_pieces_score(color)
    [Pawn, Knight, Bishop, Rook, Queen, King].each do |type|
      p_symbol = color == :white ? Paint[type::WHITE, :white] : Paint[type::BLACK, :blue]

      if type == Pawn
        p_symbol = color == :white ? Paint[type::WHITE.first, :white] : Paint[type::BLACK.first, :blue]
      end

      score = case type
              when Queen
                "#{p_symbol}  x #{board.count(type, color) + board.promoted_pawns(color)} "
              else "#{p_symbol}  x #{board.count(type, color)} "
              end
      
      print score unless board.count(type, color).zero?
    end
  end

  def double_input?(player_move_input)
    player_move_input.first.is_a?(Array)
  end

  def prompt_move_position
    puts 'What piece do you want to move?'
    puts '[Use algebraic notation, i.e.: a2a4]'

    player_move_input = nil
    loop do
      player_move_input = current_player.get_position
      break if valid_player_input?(player_move_input)
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