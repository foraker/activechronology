# ActiveChronology

Easily scope your ActiveRecord models by timestamps or dates.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activechronology', require: 'active_chronology'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activechronology

## Usage

### `set_chronology`

From your ActiveRecord models, you can add `chronological` and `reverse_chronological`
scopes by calling `set_chronology`. This accepts an attribute name as a parameter,
and it defaults to `created_at`.

### `scope_by_timestamp`

Calling `scope_by_timestamp` with a list of attribute names, you get the following
methods defined, using `:created_at` as an example:

```
created_after(time)
created_before(time)
created_between(start time, end time)
```

Here's an example class:

```ruby
class User
  set_chronology :last_seen_at
  scope_by_timestamp :last_seen_at
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activechronology. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
