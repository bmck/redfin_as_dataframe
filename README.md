# RedfinAsDataframe

Up to date housing market data access for Ruby, using Polars dataframes. 

This gem fetches housing market information from Redfin's public data API and returns the results as a Polars dataframe. For details regarding the data available from Redfin, see https://www.redfin.com/news/data-center/ .


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redfin_as_dataframe'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install redfin_as_dataframe

## Usage

### Basic Usage

Fetch all available national housing market data:

```ruby
require 'redfin_as_dataframe'

national = RedfinAsDataframe::National.new
df = national.fetch
```

This returns a Polars DataFrame with housing market metrics including median sale prices, inventory, months of supply, and more.

### Filtering by Date Range

You can filter data by specifying start and/or end dates:

```ruby
# Fetch data from a specific start date
national = RedfinAsDataframe::National.new
df = national.fetch(start: '2020-01-01')

# Fetch data up to a specific end date
df = national.fetch(fin: '2023-12-31')

# Fetch data within a date range
df = national.fetch(start: '2020-01-01', fin: '2023-12-31')
```

The `start` parameter filters to include only data where `period_begin` is on or after the specified date.
The `fin` parameter filters to include only data where `period_end` is on or before the specified date.

### Selecting Specific Data Series

You can fetch a specific data series by passing the column name to the initializer:

```ruby
# Fetch only median sale price data
national = RedfinAsDataframe::National.new('median_sale_price')
df = national.fetch

# The returned DataFrame will contain only 'Timestamps' and 'median_sale_price' columns
```

Available series include:
- `median_sale_price`, `median_list_price`
- `median_ppsf` (price per square foot), `median_list_ppsf`
- `homes_sold`, `pending_sales`, `new_listings`, `inventory`
- `months_of_supply`, `median_dom` (days on market)
- `avg_sale_to_list`, `sold_above_list`, `price_drops`
- And many more (see the full TSV data for all available columns)

## Testing

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

The test suite uses RSpec and includes:
- Unit tests for the `National` class
- Mocked HTTP requests (no live API calls during testing)
- Tests for date filtering and data series selection

To run the tests:

    $ bundle exec rake spec

Or run tests directly with RSpec:

    $ bundle exec rspec

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bmck/redfin_as_dataframe.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
