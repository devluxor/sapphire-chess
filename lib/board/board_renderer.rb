class BoardRenderer
  BOARD_ORDER = 8

  LEFT_MARGIN = 4
  RIGHT_MARGIN = 3

  EMPTY_ROW_0 =       '|        |'
  EMPTY_ROW_0_WHITE = '|████████|'
  EMPTY_ROW =         '        |'
  EMPTY_ROW_WHITE =   '████████|'

  FLOOR_0 =           '+--------+'
  FLOOR =             '--------+'

  COLUMN_LETTERS = [*('a'..'h')]
  ROW_NUMBERS =    [*('1'..'8')].reverse

  def initialize(board)
    @board = board
  end

  def render
    print_column_letters
    print_floor

    (0...BOARD_ORDER).each do |number|
      print_row(number)
      print ROW_NUMBERS[number]
      print_piece_row(number)
      puts (' ' * RIGHT_MARGIN) + ROW_NUMBERS[number].to_s
      print_row(number)
      print_floor
    end

    new_line
    print_column_letters
  end

  private

  attr_reader :board

  def print_column_letters
    COLUMN_LETTERS.each { |letter| print "        #{letter}" }
    new_line(2)
  end

  def print_row(row)
    puts row.even? ? white_starting_row : black_starting_row
  end

  def print_floor
    puts ' ' * LEFT_MARGIN + FLOOR_0 + FLOOR * (BOARD_ORDER - 1)
  end

  def new_line(lines=1)
    lines.times { puts '' }
  end

  def white_starting_row
    ' ' * LEFT_MARGIN +
      EMPTY_ROW_0_WHITE +
      (EMPTY_ROW + EMPTY_ROW_WHITE) * 3 +
      EMPTY_ROW
  end

  def black_starting_row
    ' ' * LEFT_MARGIN +
      EMPTY_ROW_0 +
      (EMPTY_ROW_WHITE + EMPTY_ROW) * 3 +
      EMPTY_ROW_WHITE
  end

  def print_piece_row(row)
    (0...BOARD_ORDER).each do |column|
      square = [row, column]

      if white_square?(square) then print_white_square(square, column)
      else print_black_square(square, column)
      end
    end
  end

  def white_square?(square)
    row = square.first
    column = square.last

    row.even? && column.even? || row.odd? && column.odd?
  end

  def print_white_square(square, column)
    print(
      if board[square].is_a?(NullPiece) && column.zero?
        "   |███#{board[square].white}███|"
      elsif column.zero?
        "   |██ #{board[square]}  ██|"
      elsif board[square].is_a?(NullPiece)
        "███#{board[square].white}███|"
      else
        "██ #{board[square]}  ██|"
      end
    )
  end

  def print_black_square(square, column)
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
