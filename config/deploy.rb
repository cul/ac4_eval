# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ac4_eval'
set :repo_url, 'git@github.com:cul/ac4_eval.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
ask :branch, proc { `git tag -l`.split("\n").last }

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/secrets.yml',
  'config/analytics.yml',
  'config/blacklight.yml',
  'config/devise.yml',
  'config/fedora.yml',
  'config/redis.yml',
  'config/role_map.yml'
)

# Default value for linked_dirs is []
# generic_linked_dirs = %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system)
# set :linked_dirs, fetch(:linked_dirs, []).push(generic_linked_dirs)
set :linked_dirs, fetch(:linked_dirs, []).push('log')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :passenger_restart_with_touch, true

namespace :deploy do
  desc "Add tag based on current version"
  task :auto_tag do
    current_version = IO.read('VERSION').to_s.strip
    yyyymmd = Date.today.strftime('%Y%m%d')
    default_tag = "v#{current_version}/#{yyyymmd}"
    ask(:tag, default_tag)
    tag = fetch(:tag)

    system("git tag -a #{tag} -m 'auto-tagged' && git push origin --tags")
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'resque:restart_workers'
        end
      end
    end
  end
end
