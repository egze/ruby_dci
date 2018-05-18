[![Build Status](https://travis-ci.org/egze/ruby_dci.svg?branch=master)](https://travis-ci.org/egze/ruby_dci)

# RubyDci

A classic DCI implementation for ruby with some extra sugar. I've been using DCI in my Rails projects and I extracted some common patters into this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_dci'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_dci

## Before you begin

First of all, make yourself familiar with [DCI](http://dci-in-ruby.info/). :

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
  config.event_routes = Hash.new([])
  config.route_methods = EventRouteStore.new
  config.transaction_class = ApplicationRecord
  config.raise_in_event_router = !Rails.env.production?
  config.logger = Rails.logger
end
```

### config.transaction_class

Usually you want your code to run in a transaction. Either everything runs fine, or nothing is saved. This is done by wrapping the executed code in a transaction block. I use ActiveRecord, but can use whatever you want. You class just needs to implement a `transaction` method that takes a block. If you don't want any transactions, you can either skip `config.transaction_class` completely, or set it to `DCI::NullTransaction`.

### config.event_routes

This is your mapping of events that may happen in the context. Key is a class name, and a value is an array of method names. Example:

```ruby
{
  DomainEvents::ProductAddedToCart => [ :send_product_added_notification ]
}
```

The system will know that it needs to execute `publish_my_event` from `config.route_methods` for every event of class `MyEvent`. If you don't have any actions that you need to perform after a transaction, the just skip `config.event_routes` completely or set it to `Hash.new([])`.

I implement events as plain ruby Structs. Example:

```ruby
module DomainEvents

  ProductAddedToCart = Struct.new(:product)

end
```

Why do I do it like this? It makes it easier to add other callbacks later. I can do it in one place instead of searching through hundreds of files. Also makes testing easier.

### config.route_methods

This is a class that implements the methods for the `config.event_routes` mapping. Example:

```ruby
class EventRouteStore

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

### config.logger

Set a logger in case there is an exception in the event router.

```ruby
config.logger = Rails.logger
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

In a Rails app I put my roles in `app/roles`. Roles are plain ruby modules. You define a role by including `DCI::Role`.

```ruby
module Customer

  include DCI::Role

  def add_to_cart!(product:)
    # do your thing

    # add event to the context
    context.events << DomainEvents::ProductAddedToCart.new(product)
  end

end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_dci.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
