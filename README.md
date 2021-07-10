# Pronto::BigFiles

[![CircleCI](https://circleci.com/gh/apiology/pronto-bigfiles.svg?style=svg)](https://circleci.com/gh/apiology/pronto-bigfiles)

Performs incremental quality reporting for the bigfiles gem.
BigFiles is a simple tool to find the largest source files in your
project; this gem plugs in with the 'pronto' gem, which does
incremental reporting using a variety of quality tools.

If you add text to a file in the top three largest files, and the
total number of lines for those three is under 300, you'll get an
alert.

If you've already configured a different threshold using the
`metrics/bigfiles_high_water_mark` (e.g., using the
[quality gem](http://github.com/apiology/quality)), pronto-bigfiles will use
that threshold instead of 300.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pronto-bigfiles'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install pronto-bigfiles
```

## Usage

This is typically used either as part a custom
[pronto](https://github.com/prontolabs/pronto) rigging, sometimes as
part of general use of the
[quality](https://github.com/apiology/quality) gem.

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake spec` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome
[on GitHub](https://github.com/apiology/pronto-bigfiles). This project is
intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[code of conduct](https://github.com/apiology/pronto-bigfiles/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pronto::BigFiles project's codebases,
issue trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/apiology/pronto-bigfiles/blob/main/CODE_OF_CONDUCT.md).
