class BoardRendererText
  attr_reader :board, :lines, :squares

  EMPTY_ROW = "        |"
  FLOOR =     "--------+"

  BOARD_ORDER = 8
  
  def initialize(board)
    @board = board
  end

  def render
    puts FLOOR * BOARD_ORDER 

    (0...BOARD_ORDER).each do |row|
      puts EMPTY_ROW * (BOARD_ORDER - 1)
      print_frame_rows(row)
      puts EMPTY_ROW * (BOARD_ORDER - 1)
      puts FLOOR * BOARD_ORDER
    end
  end

  private

  def print_frame_rows(row)
    (0...BOARD_ORDER).each do |column|
      square = [row, column]
      if column != BOARD_ORDER - 1
        print "   #{board[square]}    |"
      else
        puts  "   #{board[square]}     "
      end
    end
  end
end