# The board evaluates as inteded

# Minimax is working!!

# Now
require 'paint'
require 'pry'


module AI
  DEPTH = 3

  
  # Choose move by best outcome:
  def computer_chooses_movement
    possible_moves = board.generate_moves(:black).shuffle
    # will have: possible_moves << castling if castling_rights?

    eva = {} # Test
    best_move = possible_moves.min_by do |move|


                  evaluation = board.minimax(move, DEPTH, -Float::INFINITY, Float::INFINITY, false)


                  
                  store_evaluation(eva, move, evaluation) # Test

                  evaluation
                end
    binding.pry
    return possible_moves.sample if all_equal?(eva)
    best_move
  end


  # Testing:
  def store_evaluation(evaluations, move, evaluation)
    description = format(
      "%s %s to %s %s",
      board[move.first].class,
      move.first,
      board[move.last].class,
      move.last
    )
    evaluations[description] = evaluation
  end

  def all_equal?(evaluations)
    first_value = evaluations.values.first
    evaluations.values.all? { |value| value == first_value }
  end

end