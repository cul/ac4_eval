# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task default: :ci

if (Rails.env == "development") || (Rails.env == "test")
  require 'solr_wrapper/rake_task'
end
