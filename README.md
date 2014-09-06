# Exceptions

Exceptions is a Ruby gem that provides the right amount of abstraction for doing exception
tracking in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exceptions'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install exceptions
```

## Usage

**Track an exception**

```ruby
Exceptions.notify(StandardError.new("Boom"))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
