require_relative 'openings_and_defenses'

module AI
  include OpeningsAndDefenses

  private

  # Chooses move by best possible outcome:
  def computer_chooses_move
    return first_move(color) if first_turn?

    possible_moves = board.generate_moves(color)
    possible_moves << %i[castle king] if castle_rights?(:king)
    possible_moves << %i[castle queen] if castle_rights?(:queen)

    best_move(possible_moves)
  end

  def first_move(color)
    if color == :white then opening
    else
      defense
    end
  end

  def opening
    opening =
      case rand(1..100)
      when OPENINGS[:nf3][:probabilty] then :nf3
      when OPENINGS[:e4][:probabilty] then :e4
      when OPENINGS[:d4][:probabilty] then :d4
      when OPENINGS[:c4][:probabilty] then :c4
      end

    OPENINGS[opening][:move]
  end

  def defense
    DEFENSES[board.white_player.history.last] ||
      best_move(board.generate_moves(:black))
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

  # See README.md for an explanation of this method.
  def minimax(move, depth, alpha, beta, maximizing_player)
    return board.evaluate if depth.zero?

    board.provisional(move, color) do
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
