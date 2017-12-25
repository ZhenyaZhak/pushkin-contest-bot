# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "PushkinContestBot"
set :repo_url, "git@github.com:ZhenyaZhak/pushkin-contest-bot.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/PushkinContestBot"

set :linked_files, %w{config/database.yml, config/secrets.yml}

set :linked_dirs, %w{ log tmp/pids public/assets  tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

set :ssh_options, { :forward_agent => true }
# Default value for :pty is false
set :pty, false

set :rvm_ruby_version, '2.4.0'

set :puma_preload_app, true

set :puma_init_active_record, true

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
