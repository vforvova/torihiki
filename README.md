# Torihiki

## Introduction
Torihiki is a DSL for building business transactions built using a concept
of function composition.

>Torihiki doesn’t include error handling out of the box as it
>[dry-transaction](https://github.com/dry-rb/dry-transaction) does, but you feel
>free to use Either from [dry-monad](https://github.com/dry-rb/dry-monads)
>or anything else for it.


### What exactly is the function composition?
Function composition is applying result of a function as an argument
to the next one in a chain.

For example, we have functions `F` and `G` and a context `x`. The composition
`G` *of* `F` *of* `x`, would look like `G(F(x))`. In other words result of `F(x)`
will be received by `G` as an argument. We also could say that
`G` is *composed with* `F` or `G` is after `F`. In algebra it could be written like:

```
G(F(x)) = (G ∘ F)(x)
```


### How is this theory related to the subject?
Transactions in common are just an ordered actions around context we could think
about as a single object. Function composition is the same thing from this
point of view.


## Installation
1.  Add gem to your `Gemfile`
```ruby
gem 'torihiki', '~> 0.1.0'
```

2.  Run `bundle install`

3.  Do great things!


## Usage

### Simple transaction
Lets do very silly `SquareOfSumTransaction` which gets a hash with keys `x` and `y`
with numeric values and returns a square if their sum. It is not a real life example
but it help us explore the DSL.

Torihiki is a module which expects you to include it into your class:
```ruby
class SquareOfSumTransaction
  include Torihiki
end
```

Now we need to create some operations. The simpliest way to do it is call `map`
method and provide implementation.

>  Method `map` accepts a `block`, `proc`, `lambda` or object
>  which has method `call` implemented.

```ruby
class SquareOfSumTransaction
  include Torihiki

  map { |context| context[:x] + context[:y] }
  map { |sum| sum ** 2 }
end
```

And now lets do the calculations.
```ruby
SquareOfSumTransaction.call(x: 1, y: 2) # => 9
SquareOfSumTransaction.call(x: 3, y: 5) # => 64
```

Torihiki remembers sequence of `map` calls. When we send `call` with a context
to transaction class it will execute first block using the it. Result of the first
block call will be provided to the second one as a parameter and so on. Result
of the last one will be returned.


<!-- ### Real life transaction
How does this techniq work in real app? For example you have Playlist application
where people are able to share their playlists.
```ruby
class Authentication
end
``` -->


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

## Contribution Guide

Just add pull request =)
