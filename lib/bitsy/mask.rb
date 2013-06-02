class Bitsy
  class Mask

    attr_reader :flag, :value

    def self.with_index(flag, idx)
      self.new(flag, (1 << idx))
    end

    def initialize(flag, value)
      @flag = flag
      @value = value
    end

    def to_i
      value
    end

    def &(other)
      self.class.new(combine_flag(other, 'AND'), value & other.to_i)
    end

    def |(other)
      self.class.new(combine_flag(other, 'OR'), value | other.to_i)
    end

    def ^(other)
      self.class.new(combine_flag(other, 'XOR'), value ^ other.to_i)
    end

    def ~
      self.class.new("NOT_#{flag}".to_sym, ~value)
    end

    private

    def combine_flag(other, operation)
      if other.respond_to?(:flag)
        "#{flag}_#{operation}_#{other.flag}".to_sym
      else
        "#{flag}_#{operation}_#{other}".to_sym
      end
    end
  end
end
