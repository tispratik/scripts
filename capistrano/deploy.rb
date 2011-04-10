# RVM Bootstrap
$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.2@coeditr'	# Required so that RVM finds bundler gem in the environment and bundler installs them to that gemset
set :rvm_type, :user # :system or :user – user looks for rvm in $HOME/.rvm where as system uses the /usr/local as set for system wide installs.

# Bundler Bootstrap
require 'bundler/capistrano'

# Application Details
set :application, "<app_name>"
set :domain, "<example.com>"

# Server Roles 
role :app, domain.to_s 
role :web, domain.to_s 
role :db, domain.to_s, :primary => true 

# server details
#ssh_options[:port] = XXX		# If you have SSH server running on non standard port
set :ssh_options, { :port => XXX }	# Another way, you can pass multiple parameters

set :user, "<deployment_user>"	# The SSH username you are logging into the server(s) as.
set :use_sudo, false

default_run_options[:pty] = true
#ssh_options[:forward_agent] = true

# Repo Details
set :scm, :git
set :scm_username, "xxx@gmail.com"			# If using Github
set :repository, "git@github.com:tispratik/scripts.git"	# Repo path
set :branch, "master"

set :deploy_to, "/home/#{user}/public_html/#{application}"	# The path on the servers we’re going to be deploying the application to.
set :deploy_via, :remote_cache
#set :deploy_via, :copy
#set :git_enable_submodules, 1

set :keep_releases, 2 unless exists?(:keep_releases)

# Paths
set :shared_config_path, "#{shared_path}/config" 

def run_my_task(task)
  run "cd #{current_path} && rake #{task} RAILS_ENV=production"
end

namespace :log do
  task :prod do
    run "tail -n 200 -f #{shared_path}/log/production.log"
  end
end
 
after 'deploy:update_code', 'deploy:db:symlink'
