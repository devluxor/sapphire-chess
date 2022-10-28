class BoardRendererText
  attr_reader :board, :lines, :squares
  
  BOARD_ORDER = 8

  LEFT_MARGIN = 4
  RIGHT_MARGIN = 3

  EMPTY_ROW_0 = '|        |'
  EMPTY_ROW =   '        |'
  FLOOR_0 =     '+--------+'
  FLOOR =       '--------+'

  COLUMN_LETTERS = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
  ROW_NUMBERS = [8, 7, 6, 5, 4, 3, 2, 1]
  
  def initialize(board)
    @board = board
  end

  def render
    puts (' ' * LEFT_MARGIN) + FLOOR_0 + (FLOOR * (BOARD_ORDER - 1))

    (0...BOARD_ORDER).each do |row|
      puts (' ' * LEFT_MARGIN) + EMPTY_ROW_0 + (EMPTY_ROW * (BOARD_ORDER - 1))
      print ROW_NUMBERS[row]
      print_frame_rows(row)
      puts (' ' * RIGHT_MARGIN) + ROW_NUMBERS[row].to_s
      puts (' ' * LEFT_MARGIN) + EMPTY_ROW_0 + (EMPTY_ROW * (BOARD_ORDER - 1))
      puts (' ' * LEFT_MARGIN) + FLOOR_0 + (FLOOR * (BOARD_ORDER - 1))
    end
    puts ''
    COLUMN_LETTERS.each { |letter| print "        #{letter}" }
    puts ''
    puts ''
  end

  private

  def print_frame_rows(row)
    (0...BOARD_ORDER).each do |column|
      square = [row, column]

    print(
      if board[square].is_a?(NullPiece) && column.zero?
        "   |   #{board[square]}   |"
      elsif column.zero?
        "   |   #{board[square]}    |"
      elsif board[square].is_a?(NullPiece)
        "   #{board[square]}   |"
      else
        "   #{board[square]}    |"
      end
    )
    end
  end

  # def print_frame_rows(row)
  #   (0...BOARD_ORDER).each do |column|
  #     square = [row, column]

  #   print(
  #     if column.zero? && board[square].is_a?(NullPiece)
  #       "   |   #{board[square]}   |"
  #     elsif column.zero?
  #       "   |   #{board[square]}    |"
  #     elsif !board[square].is_a?(NullPiece) && column != BOARD_ORDER
  #       "   #{board[square]}    |"
  #     else
  #       "   #{board[square]}   |"
  #     end
  #   )
  #   end
  # end
end