# frozen_string_literal: true

class BoardRenderer
  LEFT_MARGIN = 4
  RIGHT_MARGIN = 3

  EMPTY_ROW_0 =       '|        |'
  EMPTY_ROW_0_WHITE = '|████████|'
  EMPTY_ROW =         '        |'
  EMPTY_ROW_WHITE =   '████████|'

  FLOOR_0 =           '+--------+'
  FLOOR =             '--------+'

  COLUMN_LETTERS = ('a'..'h').to_a.freeze
  ROW_NUMBERS =    [*('1'..'8')].reverse

  def initialize(board)
    @board = board
    @square_order = board.class::SQUARE_ORDER
  end

  def render
    print_column_letters
    print_floor

    print_rows

    new_line
    print_column_letters
  end

  private

  attr_reader :board, :square_order

  def print_column_letters
    COLUMN_LETTERS.each { |letter| print "        #{letter}" }
    new_line(2)
  end

  def print_floor
    puts ' ' * LEFT_MARGIN + FLOOR_0 + FLOOR * (square_order - 1)
  end

  def print_rows
    square_order.times do |number|
      print_row(number)
      print ROW_NUMBERS[number]
      print_piece_row(number)
      puts (' ' * RIGHT_MARGIN) + ROW_NUMBERS[number]
      print_row(number)
      print_floor
    end
  end

  def print_row(number)
    puts number.even? ? white_starting_row : black_starting_row
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
    square_order.times do |column|
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
      if board[square].is_a?(EmptySquare) && column.zero?
        "   |███#{board[square].white}███|"
      elsif column.zero?
        "   |██ #{board[square]}  ██|"
      elsif board[square].is_a?(EmptySquare)
        "███#{board[square].white}███|"
      else
        "██ #{board[square]}  ██|"
      end
    )
  end

  def print_black_square(square, column)
    print(
      if board[square].is_a?(EmptySquare) && column.zero?
        "   |   #{board[square]}   |"
      elsif column.zero?
        "   |   #{board[square]}    |"
      elsif board[square].is_a?(EmptySquare)
        "   #{board[square]}   |"
      else
        "   #{board[square]}    |"
      end
    )
  end

  def new_line(lines = 1)
    lines.times { puts '' }
  end
end
