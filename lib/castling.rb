module Castling
  def castle_rights?(side=:king)
    #     - two forms:
    
        #     - kingside or short (king to g1 for w., g8 for b.; rook to f1 for w., f8 for b.)
    
        #     - queenside or long (king to c1 for w., c8 for b.; rook to d1 for w., d8 for b.)
    
    # - requirements:
    
        #     - the king or the rook have been previously moved DONE
        #     - no pieces between rook and king DONE
        #     - not in check DONE
    
        #     - the castling won't result in check

    pieces_available?(side) && !board.in_check?(color) && !results_in_check?(side)
  end

  def results_in_check?(side)
    # make provisional move

    board.castle!(side, color)

    # check if player is in check?

    # unmakes provisional move

    # returns boolean
  end

  def pieces_available?(side)
    king_and_rook_unmoved?(side) && castling_line_free?(side)
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
        board[[7, 5]].empty_square? && board[[7, 6]].empty_square?
      else
        board[[7, 1]].empty_square? && board[[7, 3]].empty_square? &&
          board[[7, 3]].empty_square?
      end
    else
      if side == :king
        board[[0, 5]].empty_square? && board[[0, 6]].empty_square?
      else
        board[[0, 1]].empty_square? && board[[0, 3]].empty_square? &&
          board[[0, 3]].empty_square?
      end
    end
  end
end