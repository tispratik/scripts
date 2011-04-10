# RVM Bootstrap
$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.2@<app_name>'	# Required so that RVM finds bundler gem in the environment and bundler installs them to that gemset
set :rvm_type, :user # :system or :user – user looks for rvm in $HOME/.rvm where as system uses the /usr/local as set for system wide installs.

# Bundler Bootstrap
require 'bundler/capistrano'

# Initial database.yml creation
$LOAD_PATH.inspect
require "./config/capistrano_database"

# Application Details
set :application, "<app_name>"
set :domain, "example.com"

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
#set :scm_username, "my_github_user@gmail.com"
set :repository, "git@myserver.com:<app_name>"
set :branch, "master"

set :deploy_to, "/home/#{user}/public_html/#{application}"	# The path on the servers we’re going to be deploying the application to.
set :deploy_via, :copy
#set :deploy_via, :remote_cache
#set :git_shallow_clone, 1

set :keep_releases, 3 unless exists?(:keep_releases)

namespace :log do
  task :prod do
    run "tail -n 200 -f #{shared_path}/log/production.log"
  end
end
