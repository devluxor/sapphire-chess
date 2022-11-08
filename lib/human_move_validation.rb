module HumanMoveValidation
  def prompt_move
    puts 'What piece do you want to move?'
    puts '[Use algebraic notation, i.e.: "a2a4"]'
    puts "[To castle, \"castle (k for king side, q for queen side), i.e: \"castle k\"]\n\n"

    player_move_input = nil
    loop do
      player_move_input = current_player.get_move
      break if valid_player_input?(player_move_input)
      puts "Please, select a valid movement."
    end

    player_move_input
  end
  
  def prompt_target_square(start_square)
    target_square = nil
    puts "Where do you want to move the #{board[start_square].class}?"
    loop do
      target_square = current_player.get_move
      break if valid_target_square?(start_square, target_square)
      puts "The #{board[start_square].class} selected can't move to that square."
    end

    end_square
  end

  def valid_player_input?(player_move_input)
    if double_input?(player_move_input)
      valid_piece_selection?(player_move_input.first) &&
      valid_move?(player_move_input.first, player_move_input.last)
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

  def valid_piece_selection?(start_square)
    board[start_square].is_a?(Piece) && 
      board[start_square].color == current_player.color
  end

  def valid_move?(start_square, target_square)
    board[start_square].available_moves.include?(target_square)
  end

  def valid_castling?(side)
    current_player.castle_rights?(side)
  end

  def convert_player_input(player_move_input)
    if single_input?(player_move_input)
      start_square = player_move_input
      target_square = prompt_target_square(start_square)
    else
      start_square = player_move_input.first
      target_square = player_move_input.last
    end

    [start_square, target_square]
  end
end