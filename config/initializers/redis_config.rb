if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # We're in smart spawning mode.
    if forked
      # Re-establish redis connection
      require 'sufia/redis_config'
      Sufia::RedisConfig.configure(Sufia::RedisConfig::REDIS_CONFIG_PATH)
    end
  end
else
  Sufia::RedisConfig.configure(Sufia::RedisConfig::REDIS_CONFIG_PATH)
end
