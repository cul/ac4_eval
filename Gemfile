source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease.
# Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sufia', git: 'https://github.com/projecthydra/sufia.git', branch: 'master'
# required to handle pagination properly in dashboard.
# See https://github.com/amatsuda/kaminari/pull/322
gem 'kaminari', git: 'https://github.com/jcoyne/kaminari', branch: 'sufia'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :debug do
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using
  # <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your
  # application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development, :test do
  gem 'fcrepo_wrapper'
  gem 'solr_wrapper', '>= 0.3'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'equivalent-xml'
  gem 'factory_girl_rails', '~> 4.1'
  gem 'fuubar'
  gem 'poltergeist', '~> 1.9'
  gem 'rspec-activemodel-mocks'
  gem 'vcr'
  gem 'webmock', require: false
end

gem 'rsolr', '~> 1.0.6'
gem 'globalid'
gem 'devise'
gem 'devise-guests', '~> 0.3'
