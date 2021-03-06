[![Build Status](https://travis-ci.org/egze/ruby_dci.svg?branch=master)](https://travis-ci.org/egze/ruby_dci)
[![Coverage Status](https://coveralls.io/repos/github/egze/ruby_dci/badge.svg?branch=master)](https://coveralls.io/github/egze/ruby_dci?branch=master)

# RubyDci

A classic DCI implementation for ruby with some extra sugar. I've been using DCI in my Rails projects and I extracted some common patterns into this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_dci', require: 'dci'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_dci

## Before you begin

First of all, make yourself familiar with [DCI](http://dci-in-ruby.info/) :

> DCI (Data Context Interaction) is a new way to look at object-oriented programming. Instead of focusing on individual objects, the DCI paradigm focuses on communication between objects and makes it explicit. It improves the readability of the code, which helps programmers to reason about their programs.

With the theory out of the way, let's see what this gem will give you. You will get:

* `DCI::Context` module to include in your contexts or use cases.
* `DCI::Role` module to include in your roles.
* Transaction support for the code executed in the context.
* Event routing and processing which should run after the transaction is commited.

This is a common pattern with DCI. You run your use case, code is executed in a transaction, and then later you want to publish the result to the message broker for example.

## Usage

### Configuration

I configure the gem in `config/initializers/dci_configuration.rb`.

```ruby
DCI.configure do |config|
  config.routes = Hash.new([])
  config.router = EventRouter.new
  config.transaction_class = ApplicationRecord
  config.raise_in_event_router = !Rails.env.production?
  config.on_exception_in_router = -> (exception) {}
end
```

### config.transaction_class

Usually you want your code to run in a transaction. Either everything runs fine, or nothing is saved. This is done by wrapping the executed code in a transaction block. I use ActiveRecord, but you can use whatever you want. Your class just needs to implement a `transaction` method that takes a block. If you don't want any transactions, you can either skip `config.transaction_class` completely, or set it to `DCI::NullTransaction`.

### config.routes

This is your mapping of events that may happen in the context. Key is a class name, and the value is an array of method names. Example:

```ruby
{
  DomainEvents::ProductAddedToCart => [ :send_product_added_notification ]
}
```

The system will know that it needs to execute `send_product_added_notification` from `config.route_methods` for every event of class `DomainEvents::ProductAddedToCart`. If you don't have any actions that you need to perform after a transaction, then just skip `config.event_routes` completely or set it to `Hash.new([])`.

I implement events as plain ruby Structs. Example:

```ruby
module DomainEvents

  ProductAddedToCart = Struct.new(:product)

end
```

Why do I do it like this? It makes it easier to add other callbacks later. I can do it in one place instead of searching through hundreds of files. Also makes testing easier.

### config.router

This is a class that implements the methods for the `config.routes` mapping. Example:

```ruby
class EventRouter

  def send_product_added_notification(event)
    AddedToCartNotificationJob.perform_later(id: event.product.id)
  end

end
```

### config.raise_in_event_router

When your transaction is commited, you don't want to raise an exception during event processing. You can turn it off in production environment, but still raise when you are developing.

```ruby
config.raise_in_event_router = !Rails.env.production?
```

### config.on_exception_in_router

In case there is an exception in the event router, you can provide a handler for the exception. It should be a lambda that receives an exception as a parameter. You can use it to log the exception. If you don't need any logging, just skip `config.on_exception_in_router` completely, or assign an empty lambda.

```ruby
config.on_exception_in_router = -> (exception) { Rails.logger.error(exception) }
```


### Context

In a Rails app I put my contexts in `app/contexts`. You define a context by including `DCI::Context`.

```ruby
class AddProductToCart

  include DCI::Context

  attr_accessor :customer, :product
  def initialize(user:, product:)
    @customer = user.extend(Customer)
    @product = product
  end

  def call
     customer.add_to_cart!(product: product)
  end
end
```

Somewhere else in code, for example in a controller, you call it like this:
```ruby
AddProductToCart.call(user: current_user, product: @product)
```

Couple of thigs to keep in mind:
* The context will either succeed or raise an exception. I prefer to rescue exceptions instead of checking for result. This has a benefit of keeping my code linear, instead of `if .. else` nesting.
* There is usually no result from the `.call`. For example, if you want to create a `User` record, don't pass request params to your context, then create the object somewhere in a role and somehow try to return this object back. Instead build the User object already in the controller and pass the instance to your `.call`. Will save you a lot of headache.

### Role

In a Rails app I put my roles in `app/roles`. Roles are plain ruby modules. You define a role by including `DCI::Role`. A role has access to the `context` and to the `context_events` methods. You can push events to `context_events` to process them after the transaction.

```ruby
module Customer

  include DCI::Role

  def add_to_cart!(product:)
    # do your thing

    # add event to the context
    context_events << DomainEvents::ProductAddedToCart.new(product)
  end

end
```

## Testing

The gem includes a RSpec matcher `include_context_event`. Use it like this:

In `rails_helper.rb`:
```ruby
require 'dci/rspec/matchers'
```

In your spec:
```ruby
expect(customer).to include_context_event DomainEvent::ProductAddedToCart
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_dci.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
