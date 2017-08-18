module SimpleTransaction
  class Composition
    def initialize(composition = [])
      @composition = composition.freeze
    end

    def call(context)
      @composition.reduce(context) { |acc, func| func.call(acc) }
    end

    def map(callable = nil, &block)
      input = block || callable
      raise CompositionError.new(@composition.size) unless input.respond_to? :call
      self.class.new(@composition + [input])
    end
  end

  class CompositionError < StandardError
    def message
      "You have to specify block or provide callable argument"
    end
  end
end
