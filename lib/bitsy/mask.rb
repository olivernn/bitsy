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

    def value
      @value ||= (1 << idx)
    end

    private

  end
end
