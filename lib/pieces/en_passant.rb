require 'pry'

module EnPassant
  def add_en_passant(moves)
    adyacent_enemy_pawn = pawn_to_pass.first
    # binding.pry if location == [4, 4]
    return if adyacent_enemy_pawn.nil?

    moves << en_passant_target_square(adyacent_enemy_pawn)
  end

  def pawn_to_pass(current_square=location)
    # See Piece#safe_moves, Board#is_a_duplicate?
    return [] if board.is_a_duplicate?
    left_square = [current_square.first, current_square.last - 1]
    right_square = [current_square.first, current_square.last + 1]
    
    
    [left_square, right_square].select do |square|
      board[square].is_a?(Pawn) &&
        pawn_just_moved_two?(square)
        # board.send(enemy_player).history.last == [[square.first - 2, square.last], square]
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
    if color == :white 
      [adyacent_enemy_pawn.first - 1, adyacent_enemy_pawn.last]
    else
      [adyacent_enemy_pawn.first + 1, adyacent_enemy_pawn.last]
    end
  end
end