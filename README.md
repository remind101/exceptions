# Exceptions [![Build Status](https://travis-ci.org/remind101/exceptions.svg?branch=master)](https://travis-ci.org/remind101/exceptions)

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

## Configuration

Exceptions provides the concept of "backends" that allow you to configure what
happens when `Exceptions.notify` is called. The following backends are provided:

* **Null**: This backend does nothing. Useful in tests.
* **Raiser**: This backend will simply raise the exception.
* **Logger**: This backend will log the exception to stdout.
* **Honeybadger**: This backend will send the exception to honeybadger using the [honeybadger-ruby](https://github.com/honeybadger-io/honeybadger-ruby) gem.
* **Multi**: A meta backend to compose other backends into a single backend.
* **LogResult**: Another meta backend that wraps an existing backend to log the result in [logfmt](https://brandur.org/logfmt).

## Usage

**Track an exception**

```ruby
Exceptions.notify(StandardError.new("Boom"))
```

**Set context**

```ruby
Exceptions.context(request_id: 'dc2d304c-6276-4c1f-9f0d-cc910f4487fd')
```

**Clear context**

```ruby
Exceptions.clear_context
```

## Rack

Rack middleware is included which can be used to catch exceptions, shuttle them off somewhere and
raise the exception again.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
