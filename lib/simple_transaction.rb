module SimpleTransaction
  def call(context)
    composition.reduce(context) do |acc, func|
      func.call(acc)
    end
  end

  def map(input)
    @composition.push(fn(input))
  end

  def reduce(input)
    @composition.push(lambda(context) { context.merge(fn(input).call) })
  end

  def tap(input)
    @composition.push(lambda(context) { fn(input).call; context })
  end

  def fn(type, input)
    func = case input
    when Symbol
      method(input)]
    when Proc
      input
    end
  end

  def compose(*args)
    @composition = args.map { |func| [:reduce, func] }
  end

  def composition
    @composition || []
  end
end
