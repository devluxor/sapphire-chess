module EnPassant
  # def en_passant_available?
  #   left_square = [location.first, location.last - 1]
  #   right_square = [location.first, location.last + 1]

  #   enemy_player = color == :white ? :black_player : :white_player

  #   [left_square, right_square].any? do |square|
  #     board[square].is_a?(Pawn) &&
  #       board.send(enemy_player).history.last == [[square.first - 2, square.last], square]
  #   end
  # end

  def add_en_passant(moves)
    adyacent_pawn = pawn_to_pass
    return if adyacent_pawn.empty?
    
    diagonal = [adyacent_pawn.first - 1, adyacent_pawn.last]

    [location, diagonal]
  end

  def pawn_to_pass
    left_square = [location.first, location.last - 1]
    right_square = [location.first, location.last + 1]

    enemy_player = color == :white ? :black_player : :white_player

    [left_square, right_square].select do |square|
      board[square].is_a?(Pawn) &&
        board.send(enemy_player).history.last == [[square.first - 2, square.last], square]
    end
  end
end