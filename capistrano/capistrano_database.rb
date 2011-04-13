Capistrano::Configuration.instance.load do
  namespace :deploy do
    namespace :db do
      desc <<-DESC
        Creates the database.yml configuration file in shared path.
        By default, this task uses a template unless a template called database.yml.erb is found either is :template_dir
        or /config/deploy folders. The default template matches the template for config/database.yml file shipped with Rails.
      DESC
      task :setup, :except => { :no_release => true } do

	set(:db_username, Capistrano::CLI.ui.ask("MySQL application user: "))
	set(:db_password, Capistrano::CLI.password_prompt("MySQL application password: "))  

        default_template = <<-EOF
base: &base
  adapter: mysql
  timeout: 5000
  collation: utf8_general_ci
  encoding: utf8
  host: 127.0.0.1
production:
  database: #{application}_production
  username: #{db_username}
  password: #{db_password}
  <<: *base
        EOF

        location = fetch(:template_dir, "config/deploy") + '/database.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)
	run "mkdir -p #{shared_path}/config"
        put config.result(binding), "#{shared_path}/config/database.yml"
      end

      desc <<-DESC
        [internal] Updates the symlink for database.yml file to the just deployed release.
      DESC
      task :symlink, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
      end
    end

    after "deploy:setup",           "deploy:db:setup"   unless fetch(:skip_db_setup, false)
    after "deploy:finalize_update", "deploy:db:symlink"

  end
end
