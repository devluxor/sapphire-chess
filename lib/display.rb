module Display
  def display_turn_number
    print Paint["   Turn #{turn_number}    ", nil, :green]
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
                when :black then Paint['Black player score', :blue, :underline]
                else Paint['White player score', :white, :underline]
                end
      print message + ': '
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

  def display_check
    puts Paint[
      'You are in check!', 
      :red, :bright
      ]
  end

  def display_winner
    puts Paint[
      "#{current_player.color.to_s.capitalize} player wins!",
      nil, 
      current_player.color
    ]
  end
end