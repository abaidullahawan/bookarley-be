# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :application, "tractoronline"
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
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads', 'storage'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

before 'deploy:migrate', 'git:pull_front_end'

before 'git:wrapper', 'remove:production_log'

namespace :remove do
  desc "remove production log file"
  task :production_log do
    on roles(:web) do
      # execute("cd ~/tractoronline/current/log && rm -f production.log")
    #   execute("cd #{release_path} && cp -a ~/tractoronline-fe/build/. public/")
    end
  end
end

namespace :git do
  desc "git pull front end tractor online"
  task :pull_front_end do
    on roles(:web) do
      # execute("cd ~/tractoronline-fe && git pull origin main")
    #   execute("cd #{release_path} && cp -a ~/tractoronline-fe/build/. public/")
    end
  end
end
