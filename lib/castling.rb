module Castling
  def castle_rights?(side=:king)
    #     - two forms:
    
        #     - kingside or short (king to g1 for w., g8 for b.; rook to f1 for w., f8 for b.)
    
        #     - queenside or long (king to c1 for w., c8 for b.; rook to d1 for w., d8 for b.)
    
    # - requirements:
    
        #     - the king or the rook have been previously moved DONE
        #     - no pieces between rook and king DONE
        #     - not in check DONE
        #     - the castling won't result in check DONE
    king_and_rook_unmoved?(side) && 
      castling_line_free?(side) && 
      !board.in_check?(color) && 
      !results_in_check?(side)
  end

  def results_in_check?(side)
    board.castle!(side, color)

    in_check = board.in_check?(color)

    board.uncastle!(side, color)

    in_check
  end
    
  def king_and_rook_unmoved?(side)
    case color
    when :white
      king = [7, 4]
      rook = side == :king ? [7, 7] : [7, 4]
    else
      king = [0, 4]
      rook = side == :king ? [0, 7] : [0, 4]
    end

    !board[king].moved? && !board[rook].moved?
  end
    
  def castling_line_free?(side)
    case color
    when :white
      if side == :king
        board.empty_square?([7, 5]) && board.empty_square?([7, 6])
      else
        board.empty_square?([7, 1]) && board.empty_square?([7, 3]) &&
          board.empty_square?([7, 3])
      end
    else
      if side == :king
        board.empty_square?([0, 5]) && board.empty_square?([0, 6])
      else
        board.empty_square?([0, 1]) && board.empty_square?([0, 3]) &&
          board.empty_square?([0, 3])
      end
    end
  end
end