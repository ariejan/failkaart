set :application, "failkaart"
set :repository,  "http://github.com/ariejan/failkaart.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "80.255.251.182"
role :app, "80.255.251.182"
role :db,  "80.255.251.182", :primary => true

set :deploy_to, "/var/rails/#{application}"
set :user, "root"

desc "Hooks to runs after code update"
task :after_update_code do
  symlink_files
  chown_for_apache
end

desc "chown for webserver"
task :chown_for_apache, :roles => :app do
  run "chown -RL www-data:www-data #{release_path}"
  run "chown -RL www-data:www-data #{shared_path}"  
end

desc "Symlink files between deployments"
task :symlink_files, :roles => :db do
  run "ln -sf #{shared_path}/failkaart.db #{release_path}/failkaart.db"
  run "ln -sf #{shared_path}/twitter.yml #{release_path}/twitter.yml"
end


namespace :deploy do
  task :start do
  end
  
  task :stop do
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end