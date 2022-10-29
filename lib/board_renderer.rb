require 'paint'

class BoardRenderer
  attr_reader :board, :lines, :squares
  
  BOARD_ORDER = 8

  LEFT_MARGIN = 4
  RIGHT_MARGIN = 3

  EMPTY_ROW_0 =       '|        |'
  EMPTY_ROW_0_WHITE = '|████████|'
  EMPTY_ROW =         '        |'
  EMPTY_ROW_WHITE =   '████████|'

  FLOOR_0 =           '+--------+'
  FLOOR =             '--------+'

  WHITE_SQUARES = 9

  COLUMN_LETTERS = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
  ROW_NUMBERS = [8, 7, 6, 5, 4, 3, 2, 1]
  
  def initialize(board)
    @board = board
  end

  def render
    puts (' ' * LEFT_MARGIN) + FLOOR_0 + (FLOOR * (BOARD_ORDER - 1))

    (0...BOARD_ORDER).each do |row|
      # if row.even? then white_starting_row
      # else black_starting_row
      # end
      puts(row.even? ? white_starting_row : black_starting_row)
      print ROW_NUMBERS[row]
      print_frame_rows(row)
      puts (' ' * RIGHT_MARGIN) + ROW_NUMBERS[row].to_s
      puts(row.even? ? white_starting_row : black_starting_row)
      puts (' ' * LEFT_MARGIN) + FLOOR_0 + (FLOOR * (BOARD_ORDER - 1))
    end

    new_line
    COLUMN_LETTERS.each { |letter| print "        #{letter}" }
    new_line(2)
  end

  private

  def new_line(lines=1)
    lines.times { puts '' }
  end

  def white_starting_row
    (
      (' ' * LEFT_MARGIN) + 
      EMPTY_ROW_0_WHITE + 
      EMPTY_ROW +
      EMPTY_ROW_WHITE +
      EMPTY_ROW +
      EMPTY_ROW_WHITE +
      EMPTY_ROW +
      EMPTY_ROW_WHITE +
      EMPTY_ROW
    )
  end

  def black_starting_row
    (
      (' ' * LEFT_MARGIN) + 
      EMPTY_ROW_0 + 
      EMPTY_ROW_WHITE +
      EMPTY_ROW +
      EMPTY_ROW_WHITE +
      EMPTY_ROW +
      EMPTY_ROW_WHITE +
      EMPTY_ROW +
      EMPTY_ROW_WHITE
    )
  end

  def print_frame_rows(row)
    (0...BOARD_ORDER).each do |column|
      square = [row, column]

      print(
        if white_square?(square)
          if board[square].is_a?(NullPiece) && column.zero?
            '   |' + "███#{board[square].white}███" + '|'
          elsif column.zero?
            '   |' + "██ #{board[square]}  ██" + '|'
          elsif board[square].is_a?(NullPiece)
            "███#{board[square].white}███" + '|'
          else
            "██ #{board[square]}  ██" + '|'
          end
        else
          if board[square].is_a?(NullPiece) && column.zero?
            "   |   #{board[square]}   |"
          elsif column.zero?
            "   |   #{board[square]}    |"
          elsif board[square].is_a?(NullPiece)
            "   #{board[square]}   |"
          else
            "   #{board[square]}    |"
          end
        end
      )
    end
  end

  def white_square?(square)
    row, column = square.first, square.last

    row.even? && column.even? || row.odd? && column.odd?
  end
end