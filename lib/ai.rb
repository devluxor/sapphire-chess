require 'paint'
require 'pry'
module AI
  private

  # Chooses move by best possible outcome:
  def computer_chooses_move
    possible_moves = board.generate_moves(color)
    possible_moves << [:castle, :king] if castle_rights?(:king)
    possible_moves << [:castle, :queen] if castle_rights?(:queen)

    get_best_move(possible_moves, color)
  end

  def get_best_move(possible_moves, color)
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

    piece_buffer = make_provisional!(move)

    # This generates possible outcomes (children) for the provisional move:
    # Each branch represents the next turn (i.e.: if current player is white 
    # [the maximizing player], it generates every possible movement for the
    # next player, black [the minimizing player], who will choose the best 
    # possible move, and so on. The best (relative to each player) possible 
    # outcome for each move will determine what move is chosen)
    # See AI#computer_chooses_move

    # The alpha-beta `prunes` the tree: it makes the search more efficient
    # removing unnecessary branches, resulting in a faster process.
    best_evaluation = if maximizing_player
                        best_evaluation = Float::INFINITY

                        board.generate_moves(:black).each do |move| 
                          evaluation = minimax(move, depth - 1, alpha, beta, false)
                          best_evaluation = [best_evaluation, evaluation].min
                          beta = [beta, evaluation].min
                          break if beta <= alpha
                        end

                        best_evaluation
                      else
                        best_evaluation = -Float::INFINITY

                        board.generate_moves(:white).each do |move| 
                          evaluation = minimax(move, depth - 1, alpha, beta, true)
                          best_evaluation = [best_evaluation, evaluation].max
                          alpha = [alpha, evaluation].max
                          break if beta <= alpha
                        end

                        best_evaluation
                      end

    unmake_provisional!(piece_buffer, move)

    best_evaluation
  end

  def make_provisional!(move)
    castling = move.first == :castle

    if castling
      side = move.last
      board.castle!(side, color)
    else
      start_position, target_position = move
      piece_buffer = board[target_position]
      board.move_piece!(start_position, target_position)
    end

    piece_buffer
  end

  def unmake_provisional!(piece_buffer, move)
    castling = move.first == :castle

    if castling
      side = move.last
      board.uncastle!(side, color)
    else
      start_position, target_position = move
      board.move_piece!(target_position, start_position)
      board[target_position] = piece_buffer
    end
  end

  # This method randomizes the moves if two or more moves share the best evaluation.
  # This avoids the Computer to play the same moves every game.
  def move_randomizer(evaluations)
    best_evaluation =
    if color == :white then evaluations.values.max
    else evaluations.values.min
    end

    move = evaluations.select { |_, evaluation| evaluation == best_evaluation }.keys.sample
  end

  def anti_loop_filter(possible_moves)
    possible_moves.delete(history[-2]) if possible_moves.include?(history[-2])
  end

  # For evaluation analysis only:
  def store_evaluation(move, evaluation)
    return [move, evaluation] if move.first == :castle
    description = format(
      "%s %s to %s %s",
      board[move.first].class,
      move.first,
      board[move.last].class,
      move.last
    )

    [description, evaluation]
  end
end