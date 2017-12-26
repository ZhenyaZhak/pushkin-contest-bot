# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "PushkinContestBot"

set :repo_url, "git@github.com:ZhenyaZhak/pushkin-contest-bot.git"

#set :user, 'deployer1'

set :deploy_to, '/var/www/PushkinContestBot'

set :linked_files, %w{config/database.yml config/secrets.yml}

set :linked_dirs, %w{log tmp/pids public/assets tmp/cache tmp/sockets vendor/bundle public/system}

set :ssh_options, { :forward_agent => true }

set :pty, false

set :rvm_ruby_version, '2.4.0'

set :puma_preload_app, true

set :puma_init_active_record, true
