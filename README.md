# Yabhrg

[![Build Status](https://travis-ci.org/ceritium/yabhrg.svg?branch=master)](https://travis-ci.org/ceritium/yabhrg)

Yabhrg (yet another BambooHR gem) is a Ruby wrapper for the BambooHR API.

## Installation

The gem is not released on rubygems.org yet, but you can build it from source or use the repo url in your gemfile.

```ruby
gem 'yabhrg', git: "https://github.com/ceritium/yabhrg.git"
```

## Usage

Instantiate an api client:

```ruby
api = Yabhrg.api(api_key: "foo", subdomain: "bar")
```

There are available three main modules: `Employee`, `Metadata` and `Table` that can be instantiated with:

```ruby
Yabhrg::Employee.new(api_key: "foo", subdomain: "bar")`
Yabhrg::Metada.new(api_key: "foo", subdomain: "bar")`
Yabhrg::Table.new(api_key: "foo", subdomain: "bar")`
```

Or accessed through the api instance:

```ruby
api.employee
api.metadata
api.table
```

The available methods are distributed along theses modules pretending to look like [BambooHR documentation](https://www.bamboohr.com/api/documentation/) describes the api.

Example of some methods:

```ruby
api.employee.all
api.employee.find(42, fields: :all)
api.employee.changes_since(type: "inserted", since_at: Time.new(2016, 9, 23, 0o2, 40, 0))

api.metadata.fields
api.metadata.tables
api.metadata.lists

api.table.rows(42, "jobInfo")
api.table.add_row(42, "jobInfo", {foo: :bar, bar: :foo})
api.table.update_row(42, "jobInfo", 24, {foo: :bar, bar: :foo})
```

### Cached responses

Some methods are automaticaly cached, the cache can be flushed passing a parameter to the method, check the code see which methods are cached and the required parameters to flush the cache.

For example:

```ruby
api.metadata.fields # Cache the request
api.metadata.fields(true) # Flush and cache the request
```

## TODO

- The api is not 100% supported yet but I pretend cover it in the next weeks.
- Proper RDoc documentation.

## Similar projects

- https://github.com/Skookum/bamboozled
- https://github.com/crowdint/bamboohr

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ceritium/yabhrg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Yabhrg project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yabhrg/blob/master/CODE_OF_CONDUCT.md).
