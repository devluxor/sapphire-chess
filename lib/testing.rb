module Testing
  def move_generation_test(color, depth)    
    return 1 if depth.zero?

    possible_moves = generate_moves(color)

    number_positions = 0
    
    color = swap_color(color)
    possible_moves.each do |(start_position, target_position)|
      move_piece!(start_position, target_position) if !self[target_position].is_a?(NullPiece)
      number_positions += move_generation_test(color, depth - 1)
      move_piece!(target_position, start_position) if !self[target_position].is_a?(NullPiece)
    end

    number_positions
  end

  # If I add the move as argument to search ?

  def minimax(move, depth, alpha, beta, maximizing_player)
    return evaluate if depth.zero? # or checkmate for (white or black)

    if maximizing_player
      best_evaluation = Float::INFINITY

      start_position, target_position = move
      piece_buffer = self[target_position]
      move_piece!(start_position, target_position)

      generate_moves(:black).each do |move|
        evaluation = minimax(move, depth - 1, alpha, beta, false)
        best_evaluation = [best_evaluation, evaluation].min
        beta = [beta, evaluation].min
        break if beta <= alpha
      end

      move_piece!(target_position, start_position)
      self[target_position] = piece_buffer

      best_evaluation
    else
      best_evaluation = -Float::INFINITY

      start_position, target_position = move
      piece_buffer = self[target_position]
      move_piece!(start_position, target_position)

      generate_moves(:white).each do |move|
        evaluation = minimax(move, depth - 1, alpha, beta, true)
        best_evaluation = [best_evaluation, evaluation].max
        alpha = [alpha, evaluation].max
        break if beta <= alpha
      end

      move_piece!(target_position, start_position)
      self[target_position] = piece_buffer

      best_evaluation
    end
  end
end