require "bitsy/version"

class Bitsy
  class InvalidFlagError < StandardError ; end

  def self.flags(*flags)
    @flags = flags
  end

  def initialize(val = 0)
    self.value = val
  end

  def to_i
    value
  end

  private

  attr_reader :value

  def value=(val)
    if val.is_a? Integer
      @value = val

    elsif val.is_a? Array
      @value = 0

      val.each do |flag|
        idx = self.class.instance_variable_get("@flags").find_index(flag)
        raise InvalidFlagError unless idx

        @value |= (1 << idx)
      end

    else
      raise ArgumentError

    end
  end
end
