require 'resque'
require 'sufia/redis_config'
Sufia::RedisConfig.configure(Sufia::RedisConfig::REDIS_CONFIG_PATH)
Resque.redis = Redis.current

Resque.inline = Rails.env.test?
