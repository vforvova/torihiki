# Torihiki

Torihiki is a simple DSL inspired by [dry-transaction]() gem.
It builds a composition of functions which would help you create business
transactions without magic.

Torihiki doesn’t include error handling out of the box, but you feel free
to use [dry-either]() or anything else for it.


## What the function composition exactly is?
Function composition is applying result of a function as an argument to next one
in a chain.
For example, we have functions `F` and `G` and a context `x`. The composition
`G` *of* `F` *of* `x`, would look like `G(F(x))`. In other words result of `F(x)`
will be received by `G` as an argument. We also could say that
`G` *composed with* `F` or `G` after `F`. In algebra it could be written like:

```
G(F(x)) = (G ∘ F)(x)
```


## How is this theory related to the subject?
Transactions in common are just an ordered actions around context we could think
about as a single object. Function composition is the same thing from this
point of view.


## Installation
1.  Add gem to your `Gemfile`
```ruby
gem 'torihiki', '~> 0.1.0'
```

2.  Run `bundle install`

3. Do great things!


## Usage [WIP]
Include Torihiki into your class and use `map` to add operations into your composition

### Build simple composition [WIP]
```ruby
class Transaction
  include Torihiki

  map AuthenticationService
  map ValidationService
  map do
    # some operations
  end
  map do
    # persistence operation
  end
end

Transaction.call(context)
```

<!-- ### Usage with Dry::Either
Work in progress

### Handlers

#### tap
```ruby
def tap(input)
  map do |context|
    input.call(context)
    context
  end
end
```

#### reduce / merge
```ruby
def reduce(input)
  map do |context|
    context.merge(input.call context)
  end
end
```

#### try
```ruby
def try(input)
  map do |context|
    input.call(context)
  rescue
    context
  end
end
```

#### either
```ruby
def either(input)
  map do |context|
    Left(input.call(context))
  rescue error
    Right(error)
  end
end
```
-->

## Contribution Guide [WIP]
