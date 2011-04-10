# RVM Bootstrap
$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'

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
ssh_options[:port] = XXX	# If you have SSH server running on non standard port
set :user, "<deployment_user>"
set :use_sudo, false
default_run_options[:pty] = true
#ssh_options[:forward_agent] = true

# Repo Details
set :scm, :git
set :scm_username, "xxx@gmail.com"			# If using Github
set :repository, "git@github.com:tispratik/scripts.git"	# Repo path
set :branch, "master"

set :deploy_to, "/home/<deployment_user>/public_html/<app_name>"
set :deploy_via, :remote_cache
#set :deploy_via, :copy
#set :git_enable_submodules, 1

set :keep_releases, 2 unless exists?(:keep_releases)

# Paths
set :shared_config_path, "#{shared_path}/config" 

def run_my_task(task)
  run "cd #{current_path} && rake #{task} RAILS_ENV=production"
end

# Database
namespace :db do
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :log do
  task :prod do
    run "tail -n 200 -f #{shared_path}/log/production.log"
  end
end
 
namespace :deploy do 
  %w(start stop restart).each do |action| 
    desc "#{action} our server" 
    task action.to_sym do 
      find_and_execute_task("#{server_type}:#{action}") 
    end 
  end
end

after 'deploy:update_code', 'db:symlink'
