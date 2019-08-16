# CaptainConfig

[![Build Status](https://travis-ci.org/dirk/captain_config.svg?branch=master)](https://travis-ci.org/dirk/captain_config)

`CaptainConfig` makes it easy to add developer-friendly configuration to control your application's behavior.

## Getting Started

Add the gem to your application's Gemfile:

```rb
gem 'captain_config'
```

Run the generator to create the migration for the `captain_configs` table:

```sh
bundle exec rails generate captain_config
```

**Not on Rails?** Check out the [template](https://github.com/dirk/captain_config/blob/master/lib/generators/templates/create_captain_configs.rb.tt) for the ActiveRecord migration that would have been generated; that describes how this gem expects that table to look.

Then—assuming you're using Rails—set up some configuration in your `config/initializers`:

```rb
# config/initializers/captain_config.rb
CONFIG = CaptainConfig::Service.new do
  new_feature_enabled :boolean, default: false
  important_user_points_threshold :integer, default: 9000
end
```

Add the Puma middleware so that the configuration is reloaded out-of-band in between requests:

```rb
# config.ru
require_relative 'config/environment'

use CaptainConfig::PumaMiddleware

run Rails.application
```

Now you can read the configuration anywhere! The configuration will be reloaded in between requests, so reading it in your application is a fast hash lookup.

```rb
class User < Application
  def met_threshold?
    points >= CONFIG[:important_user_points_threshold]
  end
end
```

```erb
<% if CONFIG[:new_feature_enabled] %>
  <%= link_to 'New Stuff!', new_feature_path %>
<% end >
```

### Sidekiq

There is a Sidekiq middleware to automatically reload configuration.

```rb
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add CaptainConfig::SidekiqMiddlewareFactory.build

    # By default it only reloads every 1 second. Use the `interval:` argument
    # to change this frequency:
    #
    # chain.add CaptainConfig::SidekiqMiddlewareFactory.build(interval: 5.0)
  end
end
```

## Contributing

Clone the repo and run `bundle install` to get started developing locally.

There are integration specs which set up a sample Rails application and run tests against it. As that takes some time (more than a few seconds), there is a script to run just the non-integration specs:

```sh
./script/rspec-without-integration
```

Arguments are forwarded to RSpec, so if you want to run an individual spec file:

```sh
./script/rspec-without-integration spec/captain_config_spec.rb
```

Bug reports and pull requests are welcome on [the GitHub repository](https://github.com/dirk/captain_config).

## Code of Conduct

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Everyone interacting in the project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dirk/captain_config/blob/master/CODE_OF_CONDUCT.md).

## License

Released under the Modified BSD license, see [LICENSE](LICENSE) for details.
