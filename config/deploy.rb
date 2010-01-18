set :application, "failkaart"
set :repository,  "http://github.com/ariejan/failkaart.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "80.255.251.182"
role :app, "80.255.251.182"
role :db,  "80.255.251.182", :primary => true

set :deploy_to, "/var/rails/#{application}"
set :user, "root"

namespace :deploy do
  task :start do
  end
  
  task :stop do
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end