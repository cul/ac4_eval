require 'redis'
require 'redis-namespace'
module Sufia
  module RedisConfig
    REDIS_CONFIG_PATH = File.join(Rails.root, 'config', 'redis.yml')
    REDIS_DEFAULT_CONFIG = { thread_safe: true }.freeze
    REDIS_NAMESPACE = "#{CurationConcerns.config.redis_namespace}:#{Rails.env}".freeze
    # Parses the YAML configuration and reverse-merges with defaults
    def self.configuration(path)
      config = YAML.load(ERB.new(IO.read(path || REDIS_CONFIG_PATH)).result)[Rails.env]
      config = config.with_indifferent_access
      keys = ['host', 'port', 'password', 'url']
      config = config.select { |k, _v| keys.include?(k) || keys.include?(k.to_s) }
      REDIS_DEFAULT_CONFIG.merge(config).with_indifferent_access
    end

    # Because the .current accessor intializes a Redis
    # we must peek at the instance variable
    def self.current_redis?
      !Redis.instance_variable_get(:@current).nil?
    end

    # Disconnect the current Redis client if it exists
    def self.disconnect_current!
      Redis.current.client.disconnect if current_redis?
      Redis.current = nil
    end

    # configure Redis.current if necessary
    def self.configure(path = nil)
      config = configuration(path)

      disconnect_current!
      Redis.current = begin
        redis = Redis::Namespace.new(REDIS_NAMESPACE, redis: Redis.new(config))
      rescue
        redis = nil
      end
      # global assign necessary pending projecthydra/sufia/issues/1599
      $redis = redis
    end
  end
end
