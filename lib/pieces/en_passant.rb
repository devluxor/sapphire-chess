module EnPassant
  def add_en_passant(moves)
    adyacent_enemy_pawn = pawn_to_pass(location).first
    return if adyacent_enemy_pawn.nil?

    diagonal = [adyacent_enemy_pawn.first - 1, adyacent_enemy_pawn.last]

    moves << diagonal
  end

  def pawn_to_pass(current_square)
    # See Piece#safe_moves, Board#is_a_duplicate?
    return [] if board.is_a_duplicate?

    left_square = [current_square.first, current_square.last - 1]
    right_square = [current_square.first, current_square.last + 1]

    enemy_player = color == :white ? :black_player : :white_player
    
    [left_square, right_square].select do |square|
      board[square].is_a?(Pawn) &&
        board.send(enemy_player).history.last == [[square.first - 2, square.last], square]
    end
  end
end