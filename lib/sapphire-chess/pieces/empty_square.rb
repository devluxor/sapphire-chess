require 'singleton'

class EmptySquare
  include Singleton

  def to_s
    '  '
  end

  def white
    '██'
  end

  def hash_value
    '0'
  end
end
