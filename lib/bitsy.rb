require "bitsy/version"
require "bitsy/mask"

class Bitsy
  class InvalidFlagError < StandardError ; end

  def self.flags(*flags)
    if flags.empty?
      @flags
    else
      @flags = flags
    end
  end

  def self.masks
    @masks ||= flags.map.with_index do |flag, idx|
      Bitsy::Mask.new(flag, idx)
    end
  end

  def initialize(val = 0)
    self.value = val
  end

  def to_i
    value
  end

  def to_a
    self.class.masks.each_with_object([]) do |mask, memo|
      memo << mask.flag unless (value & mask.value).zero?
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
        mask = self.class.masks.find { |m| m.flag == flag }
        raise InvalidFlagError unless mask

        @value |= mask.value
      end

    else
      raise ArgumentError

    end
  end
end
