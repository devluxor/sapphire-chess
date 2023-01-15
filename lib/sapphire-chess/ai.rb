module AI
  private

  # Chooses move by best possible outcome:
  def computer_chooses_move
    possible_moves = board.generate_moves(color)
    possible_moves << %i[castle king] if castle_rights?(:king)
    possible_moves << %i[castle queen] if castle_rights?(:queen)

    best_move(possible_moves)
  end

  def best_move(possible_moves)
    evaluations = {}
    anti_loop_filter(possible_moves)

    possible_moves.each do |move|
      evaluations[move] = 
      minimax(move, depth, -Float::INFINITY, Float::INFINITY, maximizing_player?)
    end

    move_randomizer(evaluations)
  end

  def minimax(move, depth, alpha, beta, maximizing_player)
    return board.evaluate if depth.zero?

    move_final_evaluation =
    board.provisional(move, color) do
      # This generates possible outcomes (children) for the provisional move:
      # Each branch represents the next turn (i.e.: if current player is white
      # [the maximizing player], it generates every possible movement for the
      # next player, black [the minimizing player], who will choose the best
      # possible move, and so on. The best (relative to each player) possible
      # outcome for each move will determine what move is chosen, `best_evaluation`)
      # See AI#computer_chooses_move

      # The alpha-beta `prunes` the tree: it makes the search more efficient
      # removing unnecessary branches, resulting in a faster process.
      move_final_evaluation =
        if maximizing_player
          best_minimizing_evaluation = Float::INFINITY

          board.generate_moves(:black).each do |possible_move|
            evaluation = minimax(possible_move, depth - 1, alpha, beta, false)
            best_minimizing_evaluation = [best_minimizing_evaluation, evaluation].min
            beta = [beta, evaluation].min
            break if beta <= alpha
          end

          best_minimizing_evaluation
        else
          best_maximizing_evaluation = -Float::INFINITY

          board.generate_moves(:white).each do |possible_move|
            evaluation = minimax(possible_move, depth - 1, alpha, beta, true)
            best_maximizing_evaluation = [best_maximizing_evaluation, evaluation].max
            alpha = [alpha, evaluation].max
            break if beta <= alpha
          end

          best_maximizing_evaluation
        end
    end

    move_final_evaluation
  end

  # This method randomizes the moves if two or more moves share the best evaluation.
  # This avoids the Computer to play the same moves every game.
  def move_randomizer(evaluations)
    best_evaluation =
      if color == :white then evaluations.values.max
      else
        evaluations.values.min
      end

    evaluations.select do |_, evaluation|
      evaluation == best_evaluation
    end.keys.sample
  end

  def anti_loop_filter(possible_moves)
    possible_moves.delete(history[-2]) if possible_moves.include?(history[-2])
  end

  # For evaluation analysis only:
  def store_evaluation(move, evaluation)
    return [move, evaluation] if move.first == :castle

    description = format(
      '%<piece_class>s %<piece_position>s to %<target_class>s %<target_position>s',
      piece_class: board[move.first].class,
      piece_position: move.first,
      target_class: board[move.last].class,
      target_position: move.last
    )

    [description, evaluation]
  end
end
