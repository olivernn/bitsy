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
      mask = Bitsy::Mask.with_index(flag, idx)
      self.const_set(flag.upcase, mask)
      mask
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

  def method_missing(name, *args, &block)
    super unless name.match(/^has_/)

    if name.match(/_or_/)
      some(*name.to_s.gsub(/^has_/, '').split(/_or_/))
    else
      every(*name.to_s.gsub(/^has_/, '').split(/_and_/))
    end
  end

  def every(*flags)
    flags.inject(true) do |memo, flag|
      mask = self.class.masks.find { |m| m.flag == flag.to_sym }
      raise InvalidFlagError.new(flag) unless mask
      memo && !(value & mask.value).zero?
    end
  end

  def some(*flags)
    flags.inject(false) do |memo, flag|
      mask = self.class.masks.find { |m| m.flag == flag.to_sym }
      raise InvalidFlagError.new(flag) unless mask
      memo || !(value & mask.value).zero?
    end
  end

  def set(*flags)
    self.value = flags
  end

  alias_method :<<, :set

  def unset(*flags)
    masks_for_flags(flags) do |mask|
      self.value = value & ~mask.value
    end
  end

  def toggle(*flags)
    masks_for_flags(flags) do |mask|
      self.value = value ^ mask.value
    end
  end

  def &(other)
    self.class.new(value & other.to_i)
  end

  def |(other)
    self.class.new(value | other.to_i)
  end

  def ^(other)
    self.class.new(value ^ other.to_i)
  end

  private

  attr_reader :value

  def masks_for_flags(flags)
    flags.each do |flag|
      mask = self.class.masks.find { |m| m.flag == flag }
      raise InvalidFlagError unless mask
      yield mask
    end
  end

  def value=(val)
    if val.is_a? Integer
      @value = val

    elsif val.is_a? Array
      @value = 0 if @value.nil?

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
