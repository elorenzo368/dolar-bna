# Dolar::Bna


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dolar-bna'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dolar-bna

## Usage

After gem install run
  $ rails g dolar:bna:install

And
  $ rake db:migrate

To run conversions DOLAR to ARS

  Dolar::Bna::Convert.new(value_to_convert, "usd_to_ars").perform

To run conversions DOLAR to ARS

  Dolar::Bna::Convert.new(value_to_convert, "ars_to_usd").perform

all dolar prices are saved in BD in table dolar_cotizations. To obtain cotizations do:

  Dolar::Bna::DolarCotization.all


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dolar-bna. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dolar::Bna project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dolar-bna/blob/master/CODE_OF_CONDUCT.md).
