require "bitsy/version"

class Bitsy
  class InvalidFlagError < StandardError ; end

  def self.flags(*flags)
    if flags.empty?
      @flags
    else
      @flags = flags
    end
  end

  def initialize(val = 0)
    self.value = val
  end

  def to_i
    value
  end

  def to_a
    self.class.flags.each_with_object([]).with_index do |(flag, memo), idx|
      mask = (1 << idx)
      memo << flag unless (value & mask).zero?
    end
  end

  private

  attr_reader :value

  def value=(val)
    if val.is_a? Integer
      @value = val

    elsif val.is_a? Array
      @value = 0

      val.each do |flag|
        idx = self.class.flags.find_index(flag)
        raise InvalidFlagError unless idx

        @value |= (1 << idx)
      end

    else
      raise ArgumentError

    end
  end
end
