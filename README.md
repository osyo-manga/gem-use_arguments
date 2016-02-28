[![Build Status](https://travis-ci.org/osyo-manga/gem-use_arguments.svg?branch=master)](https://travis-ci.org/osyo-manga/gem-use_arguments)

# UseArguments

Use arguments keyword in block.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'use_arguments'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install use_arguments

## Usage

```ruby
require "use_arguments"

=begin
	Implicitly defined parameters in block.
	_1, _2..._N : argument value.
	_args       : argument array.
	_self       : self Proc object.
	_yield      : block argument.
=end

# UseArguments::{Use args class name}
using UseArguments::Array
# or
# using UseArguments.usable Array

p [1, 2, 3].map { _1 + _1 }
# => [2, 4, 6]

using UseArguments::Hash
p ({homu: 13, mami: 14, mado: 13}).select { _2 < 14 }
# => {:homu=>13, :mado=>13}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/osyo-manga/use_arguments.

## Special Thanks

* [supermomonga](http://qiita.com/supermomonga/items/b0576847b1b88e3cd400)


