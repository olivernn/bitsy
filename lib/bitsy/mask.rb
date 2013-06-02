class Bitsy
  class Mask

    attr_reader :flag

    def initialize(flag, idx)
      @flag = flag
      @idx = idx
    end

    def value
      @value ||= (1 << idx)
    end

    private

    attr_reader :idx
  end
end
