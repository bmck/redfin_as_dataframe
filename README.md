# RedfinAsDataframe

Up to date remote economic data access for ruby, using Polars dataframes. 

This package will fetch economic and financial information from Redfin's API, and return the results as a Polars dataframe.  For details regarding the data available from Redfin, see https://www.redfin.com/news/data-center/ .


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

```{ruby}
3.1.2 :001 > RedfinAsDataframe::National.new.fetch
 => 
shape: (900, 48)                                                                                      
┌────────────┬──────────────┬────────────┬───────────────────────────┬───┬─────────────────────────┬─────────────────────────────┬─────────────────────────────┬─────────────────────┐
│ Timestamps ┆ period_begin ┆ period_end ┆ property_type             ┆ … ┆ off_market_in_two_weeks ┆ off_market_in_two_weeks_mom ┆ off_market_in_two_weeks_yoy ┆ last_updated        │
│ ---        ┆ ---          ┆ ---        ┆ ---                       ┆   ┆ ---                     ┆ ---                         ┆ ---                         ┆ ---                 │
│ date       ┆ date         ┆ date       ┆ str                       ┆   ┆ f64                     ┆ f64                         ┆ f64                         ┆ str                 │
╞════════════╪══════════════╪════════════╪═══════════════════════════╪═══╪═════════════════════════╪═════════════════════════════╪═════════════════════════════╪═════════════════════╡
│ 2012-01-01 ┆ 2012-01-01   ┆ 2012-01-31 ┆ All Residential           ┆ … ┆ 0.268978                ┆ 0.05758                     ┆ 0.042427                    ┆ 2024-07-15 17:34:50 │
│ 2012-01-01 ┆ 2012-01-01   ┆ 2012-01-31 ┆ Single Family Residential ┆ … ┆ 0.264943                ┆ 0.057888                    ┆ 0.042966                    ┆ 2024-07-15 17:34:50 │
│ 2012-01-01 ┆ 2012-01-01   ┆ 2012-01-31 ┆ Condo/Co-op               ┆ … ┆ 0.261377                ┆ 0.056769                    ┆ 0.047681                    ┆ 2024-07-15 17:34:50 │
│ 2012-01-01 ┆ 2012-01-01   ┆ 2012-01-31 ┆ Multi-Family (2-4 Unit)   ┆ … ┆ 0.284983                ┆ 0.046932                    ┆ 0.034672                    ┆ 2024-07-15 17:34:50 │
│ 2012-01-01 ┆ 2012-01-01   ┆ 2012-01-31 ┆ Single Units Only         ┆ … ┆ 0.268479                ┆ 0.05802                     ┆ 0.042755                    ┆ 2024-07-15 17:34:50 │
│ …          ┆ …            ┆ …          ┆ …                         ┆ … ┆ …                       ┆ …                           ┆ …                           ┆ …                   │
│ 2024-06-01 ┆ 2024-06-01   ┆ 2024-06-30 ┆ Single Units Only         ┆ … ┆ 0.391207                ┆ -0.015626                   ┆ -0.038292                   ┆ 2024-07-15 17:34:50 │
│ 2024-06-01 ┆ 2024-06-01   ┆ 2024-06-30 ┆ Multi-Family (2-4 Unit)   ┆ … ┆ 0.379549                ┆ -0.004404                   ┆ -0.023177                   ┆ 2024-07-15 17:34:50 │
│ 2024-06-01 ┆ 2024-06-01   ┆ 2024-06-30 ┆ All Residential           ┆ … ┆ 0.39092                 ┆ -0.015381                   ┆ -0.038202                   ┆ 2024-07-15 17:34:50 │
│ 2024-06-01 ┆ 2024-06-01   ┆ 2024-06-30 ┆ Condo/Co-op               ┆ … ┆ 0.311552                ┆ -0.007067                   ┆ -0.05425                    ┆ 2024-07-15 17:34:50 │
│ 2024-06-01 ┆ 2024-06-01   ┆ 2024-06-30 ┆ Single Family Residential ┆ … ┆ 0.401831                ┆ -0.015627                   ┆ -0.035427                   ┆ 2024-07-15 17:34:50 │
└────────────┴──────────────┴────────────┴───────────────────────────┴───┴─────────────────────────┴─────────────────────────────┴─────────────────────────────┴─────────────────────┘ 
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake none` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/redfin_as_dataframe.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
