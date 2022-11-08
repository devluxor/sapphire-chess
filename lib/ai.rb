require 'paint'

module AI
  # Levels of recursion. 
  # Deeper means harder (computer can think DEPTH turns ahead)
  DEPTH = 3

  private
  
  # Choose move by best possible outcome:
  def computer_chooses_move
    possible_moves = board.generate_moves(:black)
    possible_moves << [:castle, :king] if castle_rights?(:king)
    possible_moves << [:castle, :queen] if castle_rights?(:queen)

    # eva = [] # Test
    best_move = possible_moves.min_by do |move|
                  # evaluation = 
                  minimax(move, DEPTH, -Float::INFINITY, Float::INFINITY, false)
                  # eva << store_evaluation(move, evaluation) # Test
                  # evaluation
                end

    # eva.sort_by! { |evaluation| evaluation.last }
    # binding.pry
    
    best_move
  end

  def minimax(move, depth, alpha, beta, maximizing_player)
    return board.evaluate if depth.zero?

    castling = move.first == :castle

    # Makes provisional move
    if castling
      board.castle!(move.last, color)
    else
      start_position, target_position = move
      piece_buffer = board[target_position]
      board.move_piece!(start_position, target_position)
    end

    # This generates possible outcomes (children) for the provisional move:
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
                      
    # Unmakes provisional move:
    if castling
      board.uncastle!(move.last, color)
    else
      board.move_piece!(target_position, start_position)
      board[target_position] = piece_buffer
    end
    
    best_evaluation
  end

  # Testing:
  def store_evaluation(move, evaluation)
    description = format(
      "%s %s to %s %s",
      board[move.first].class,
      move.first,
      board[move.last].class,
      move.last
    )

    [description, evaluation]
  end

  def all_equal?(evaluations)
    evaluations.map(&:last).uniq.size == 1
  end
end