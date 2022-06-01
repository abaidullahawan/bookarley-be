# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :application, "tractor-online"
set :repo_url, "git@github.com:abaidullahawan/tractoronline.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

set :branch, 'production'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh
set :pty, false

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/settings.yml'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

before "git:wrapper", "deploy:remove_logs"
namespace :deploy do
  desc 'Removeing log files'
  task :remove_logs do
    on roles(:web) do
      within release_path do
        execute("cd $HOME/tractor-online/shared && rm -r log")
      end
    end
  end
end

before "deploy:assets:precompile", "deploy:npm_install"
namespace :deploy do
  desc "Run rake npm install"
  task :npm_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && npm install")
      end
    end
  end
end
