module EnPassantPieceControl
  def add_en_passant(moves)
    adyacent_enemy_pawn = pawn_to_pass.first
    return if adyacent_enemy_pawn.nil?

    moves << en_passant_target_square(adyacent_enemy_pawn)
  end

  def pawn_to_pass(current_square=location)
    # See Piece#safe_moves, Board#is_a_duplicate?
    return [] if board.is_a_duplicate?

    left_square = [current_square.first, current_square.last - 1]
    right_square = [current_square.first, current_square.last + 1]
    
    [left_square, right_square].select do |square|
      board[square].is_a?(Pawn) && pawn_just_moved_two?(square)
    end
  end

  def pawn_just_moved_two?(square)
    if color == :white
      board.black_player.history.last == 
        [[square.first - 2, square.last], square]
    else
      board.white_player.history.last == 
        [[square.first + 2, square.last], square]
    end
  end

  def en_passant_target_square(adyacent_enemy_pawn)
    direction = color == :white ? -1 : 1
      
    [adyacent_enemy_pawn.first + direction, adyacent_enemy_pawn.last]
  end
end

module EnPassantBoardControl
  def capture_passed_pawn(target_square)
    captured_pawn = passed_pawn(target_square)

    self[captured_pawn] = NoPiece.instance
  end

  def was_en_passant?(piece, target_square)
    captured_pawn = passed_pawn(target_square)
    
    self[target_square].is_a?(Pawn) &&
      self[target_square].pawn_to_pass(piece).include?(captured_pawn)
  end

  def passed_pawn(target_square)
    direction = self[target_square].color == :white ? 1 : -1

    [target_square.first + direction, target_square.last]
    end
  end
end