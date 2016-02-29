require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SufiaEval
  class Application < Rails::Application
    include Cul::Omniauth::FileConfigurable
    config.generators do |g|
      g.test_framework :rspec, spec: true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    # Uncomment below if autoloading from lib is desirable
    # config.autoload_paths += Dir["#{config.root}/lib/**/*"]
    # config.autoload_paths << Rails.root.join('lib')
    require 'sufia/redis_config'

    # testable override necessary pending https://github.com/cul/cul_omniauth/issues/2
    def self.cas_configuration_opts
      if File.exist?(File.join(Rails.root, 'config', 'cas.yml'))
        super
      else
        @cas_opts = { provider: '' }
      end
    end
  end
end
