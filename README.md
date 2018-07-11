# AnotherGrapeCache

Here is yet another implementation for Grape cache. 
This implementation based on middlewares, a standard extension interface of Grape.
Response body cached effectively on response status 200 in a format of API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'another_grape_cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install another_grape_cache

## Usage

### Initializer

```Ruby
    # config/another_grape_cache.rb
    
    AnotherGrapeCache.configure do |config|
      config.cache_backend = Rails.cache
      config.perform_caching = true
    end
```

  * `cache_backend` - should implement a public interface of read/write/exists? as a standard `Rails.cache`
  * `perform_caching` - toggles caching (might be disabled for dev) 

### Inside Endpoint

```Ruby
    # app/api/posts/index_endpoint.rb
    
    include AnotherGrapeCache::CacheHelper

    helpers do
      def posts
        @posts ||= Post.limit(10)
      end
    end

    cache(max_age: 10.minutes, expires_in: 5.minutes, private_cache: true, cache_if: -> { rand(2) == 1 }) do
      posts.cache_key
    end
    
    get do
      present posts
    end
```
    
### Options
    
  * `max_age` - ActiveSupport time range, max cache time for client. Max age set as directive of the HTTP header `Cache-Control`, default 0
  * `private_cache` - Boolean, set `private/public` for the HTTP header `Cache-Control`, default false. 
  * `expires_in` - parameter for caching backend (max time to live).
  * `cache_if` - a lambda which must return a Boolean value. The lambda is executed in the context of an endpoint
  * `block` - should return a value for `cache_key`. This block is executed inside a route context, helpers are available there

Cache hit/miss status exposed as a HTTP header `X-Cache-Status: MISS/HIT`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SamMolokanov/another_grape_cache. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AnotherGrapeCache project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SamMolokanov/another_grape_cache/blob/master/CODE_OF_CONDUCT.md).
