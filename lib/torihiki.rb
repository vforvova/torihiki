require 'torihiki/composition'

module Torihiki
  def self.included(host)
    host.extend(ClassMethods)
  end

  module ClassMethods
    def map(input)
      @io = io.map(input.is_a?(Symbol) ? method(input) : input)
      self
    end

    def call(context)
      io.call(context)
    end

    private

    def io
      @io ||= Composition.new
    end
  end
end
