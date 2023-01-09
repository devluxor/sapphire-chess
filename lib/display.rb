module Display
  CURRENT_VERSION = 'v0.7.0'
  
  def clear_screen
    system 'clear'
  end

  def new_line(lines=1)
    puts '' * lines
  end

  def display_welcome
    clear_screen

    print '♟  ♞  ♝  ♜  ♛  ♚ '
    print Paint[" 💎  Welcome to Sapphire Chess #{CURRENT_VERSION}! 💎 ", :green]
    puts Paint[' ♚  ♛  ♜  ♝  ♞  ♟', :blue]
    new_line
  end

  def display_game_modes
    puts "Please, select the game mode: (1/2)\n\n"\
      "1) You against the machine.\n\n"\
      "2) You against a friend using the same computer.\n\n"
  end

  def display_difficulty_settings
    puts "Please, enter the game difficulty:\n"\
      "[i.e.: \"1\", \"e\" or \"easy\" to select Easy]\n\n"\
      "1) Easy\n2) Medium\n3) Hard\n\n"\
      "This setting determines how many turns the computer can think ahead.\n"\
      'Warning: the "hard" setting is very hard!'
  end

  def display_move_message
    puts 'What piece do you want to move?'
    puts '[Use algebraic notation, i.e.: "a2a4"]'
    puts "[To castle, \"castle (k for king side, q for queen side), "\
         "i.e: \"castle k\"]\n\n"
  end
  
  def display_last_moves
    return if turn_number < 2
    print Paint['Last moves: ', :green]
    display_move(:white)
    display_move(:black)
    
    new_line
  end

  def display_move(color)
    player = color == :white ? white_player : black_player
      
    if color == :white
      print Paint["White #{player.last_move}"]
      print Paint[' | ', :green]
    else
      puts Paint["Black #{player.last_move}", :blue]
    end
  end

  def display_turn_number
    print Paint["   Turn #{turn_number.to_i}    ", nil, :green]
  end

  def display_player_turn
    puts Paint[
      "It's #{current_player.color}'s turn!",
      nil,
      current_player.color,
      :bright
    ]
  end

  def display_graphic_score
    [:black, :white].each do |color|
      message = case color
                when :white then Paint['White player score', :white, :underline]
                else Paint['Black player score', :blue, :underline]
                end
      print message + ': '
      display_pieces_score(color)
      new_line(2)
    end
  end

  def display_pieces_score(color)
    [Pawn, Knight, Bishop, Rook, Queen, King].each do |type|
      piece_symbol = get_piece_symbol(color, type)

      score_line = if type == Queen
                     "#{piece_symbol} x "\
                     "#{board.count(type, color) + board.promoted_pawns(color)} "
                   elsif type == Pawn
                     "#{piece_symbol} x "\
                     "#{board.count(type, color) - board.promoted_pawns(color)} "
                   else 
                     "#{piece_symbol} x #{board.count(type, color)} "
                   end

      print score_line unless score_line[-2] == "0"
    end
  end

  def get_piece_symbol(color, type)
    if type == Pawn
      if color == :white then Paint[type::WHITE.first, :white]
      else Paint[type::BLACK.first, :blue]
      end
    else
      if color == :white then Paint[type::WHITE, :white]
      else Paint[type::BLACK, :blue]
      end
    end
  end

  def display_check
    puts Paint['You are in check!', :red, :bright]
    new_line
  end

  def display_checkmate
    puts Paint['Checkmate!', nil, :red, :bright]
    new_line
  end

  def display_winner
    puts Paint[
      "#{current_player.color.to_s.capitalize} player wins!",
      nil,
      current_player.color
    ]
    puts 'Thanks for playing Ruby Chess'
  end
end
