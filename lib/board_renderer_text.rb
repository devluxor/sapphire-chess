class BoardRendererText
  attr_reader :board, :lines, :squares

  EMPTY_ROW_0 = '|        |'
  EMPTY_ROW =   '        |'
  FLOOR_0 =     '+--------+'
  FLOOR =       '--------+'

  BOARD_ORDER = 8
  
  def initialize(board)
    @board = board
  end

  def render
    puts (' ' * 4) + FLOOR_0 + (FLOOR * (BOARD_ORDER - 1))

    (0...BOARD_ORDER).each do |row|
      puts (' ' * 4) + EMPTY_ROW_0 + (EMPTY_ROW * (BOARD_ORDER - 1))
      print_frame_rows(row)
      puts (' ' * 4) + EMPTY_ROW_0 + (EMPTY_ROW * (BOARD_ORDER - 1))
      puts (' ' * 4) + FLOOR_0 + (FLOOR * (BOARD_ORDER - 1))
      puts '        T' * BOARD_ORDER if row == BOARD_ORDER - 1
    end

    puts ''
  end

  private

  def print_frame_rows(row)
    (0...BOARD_ORDER).each do |column|
      square = [row, column]

      if column.zero? && board[square].is_a?(NullPiece)
        print  "T   |   #{board[square]}   |"
      elsif column.zero?
        print  "T   |   #{board[square]}    |"
      elsif column != BOARD_ORDER - 1 && !board[square].is_a?(NullPiece)
        print  "   #{board[square]}    |"
      elsif column != BOARD_ORDER - 1
        print  "   #{board[square]}   |"
      else
        print  "   #{board[square]}   |"
        puts '        TEST'
      end
    end
  end
end