# RVM Bootstrap
$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.2@<app_name>'	# Required so that RVM finds bundler gem in the environment and bundler installs them to that gemset
set :rvm_type, :user 			# :system or :user – user looks for rvm in $HOME/.rvm where as system uses the /usr/local as set for system wide installs.

# Bundler Bootstrap
require 'bundler/capistrano'

# Initial database.yml creation
$LOAD_PATH.inspect
require "./config/capistrano_database"

# Application Details
set :application, "<app_name>"
set :domain, "<app_name>.com"

# Server Roles 
role :app, domain.to_s 
role :web, domain.to_s 
role :db, domain.to_s, :primary => true 

# server details
set :ssh_options, { :port => XXX }	# You can pass multiple parameters
set :user, "deploy"			# The SSH username you are logging into the server(s) as.
set :use_sudo, false

default_run_options[:pty] = true
#ssh_options[:forward_agent] = true

# Repo Details
set :scm, :git
#set :scm_username, "githubuser@gmail.com"
set :repository, "git@server.com:<app_name>"
set :branch, "master"

set :deploy_to, "/home/#{user}/public_html/#{application}"	# The path on the servers we’re going to be deploying the application to.
set :deploy_via, :copy
#set :deploy_via, :remote_cache
#set :git_shallow_clone, 1

set :keep_releases, 3 unless exists?(:keep_releases)

#=========================================================================================================================================================

#---Unicorn---#
set :server_type, :unicorn unless exists?(:server_type) 
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

namespace :unicorn do
  desc "Start Unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && bundle exec unicorn_rails -c #{unicorn_config} -E production -D"
  end
  desc "Stop Unicorn"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  desc "Gracefully stop Unicorn"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc "Reload Unicorn"
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  desc "Restart Unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  after "deploy:restart", "unicorn:reload"
end
#---Unicorn---#

#---Magic---#
namespace :deploy do 
  %w(start stop restart).each do |action| 
    desc "#{action} our server" 
    task action.to_sym do 
      find_and_execute_task("#{server_type}:#{action}") 
    end 
  end
end
#---Magic---#

#---Custom---#
namespace :log do
  task :prod do
    run "tail -n 200 -f #{shared_path}/log/production.log"
  end
end
#---Custom---#
