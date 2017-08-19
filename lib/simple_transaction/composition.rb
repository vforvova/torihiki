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
      raise ComposedNonCallableError.new(@composition.size) unless input.respond_to? :call
      self.class.new(@composition + [input])
    end
  end

  class ComposedNonCallableError < StandardError
    def message
      "Composition recieved a function which does not respond to method call"
    end
  end
end
