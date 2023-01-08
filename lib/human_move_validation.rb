module HumanMoveValidation
  def prompt_color
    puts "What color would you like to play? ([W]hite/[B]lack)"
    choice = nil
    loop do
      choice = gets.chomp.strip.downcase
      break if valid_color?(choice)
      puts 'Please, enter a valid color choice.'
    end
    choice
  end

  def valid_color?(choice)
    %w(white black w b).include?(choice)
  end

  def prompt_difficulty
    display_difficulty_settings
    difficulty_input = nil
    loop do
      difficulty_input = gets.chomp.strip.downcase
      break if valid_difficulty?(difficulty_input)
      puts 'Please, enter a valid difficulty setting.'
    end
    difficulty_input
  end

  def display_difficulty_settings
    puts "Please, enter the game difficulty:\n"\
      "[i.e.: \"1\", \"e\" or \"easy\" to select Easy]\n\n"\
      "1) Easy\n2) Medium\n3) Hard\n\n"\
      "This setting determines how many turns the computer can think ahead.\n"\
      'Caveat: the "hard" setting is very hard!'
  end

  def valid_difficulty?(difficulty)
    %w(easy medium hard 1 2 3).include?(difficulty)
  end

  def prompt_move
    puts 'What piece do you want to move?'
    puts '[Use algebraic notation, i.e.: "a2a4"]'
    puts "[To castle, \"castle (k for king side, q for queen side), "\
         "i.e: \"castle k\"]\n\n"

    player_move_input = nil
    loop do
      player_move_input = current_player.get_move
      break if valid_player_input?(player_move_input)
      puts "Please, select a valid movement."
    end

    player_move_input
  end
  
  def prompt_target_square(piece)
    target_square = nil
    puts "Where do you want to move the #{board[piece].class}?"
    loop do
      target_square = current_player.get_move
      break if valid_target_square?(piece, target_square)
      puts "The #{board[piece].class} selected can't move to that square."
    end

    target_square
  end

  def valid_player_input?(player_move_input)
    if double_input?(player_move_input)
      valid_piece_selection?(player_move_input.first) &&
        valid_target_square?(player_move_input.first, player_move_input.last)
    elsif player_move_input.first == :castle
      valid_castling?(player_move_input.last)
    else
      valid_piece_selection?(player_move_input)
    end
  end

  def double_input?(player_move_input)
    player_move_input.first.is_a?(Array)
  end

  def single_input?(player_move_input)
    player_move_input.first.is_a?(Integer)
  end

  def valid_piece_selection?(piece)
    board[piece].is_a?(Piece) && 
      board[piece].color == current_player.color
  end

  def valid_target_square?(piece, target_square)
    board[piece].available_moves.include?(target_square)
  end

  def valid_castling?(side)
    current_player.castle_rights?(side)
  end

  def convert_player_input(player_move_input)
    if single_input?(player_move_input)
      piece = player_move_input
      target_square = prompt_target_square(piece)
    else
      piece = player_move_input.first
      target_square = player_move_input.last
    end

    [piece, target_square]
  end
end