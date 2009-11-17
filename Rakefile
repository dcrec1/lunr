# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :stories do
  def execute(cmd)
    success = system cmd
    yield
    raise unless success
  end

  task :default do
    execute "cucumber RAILS_ENV=cucumber"
  end

  task :enhanced => [:'culerity:rails:start'] do
    execute "cucumber -p enhanced RAILS_ENV=culerity_continuousintegration" do
      execute "rake culerity:rails:stop"
    end
  end

  task :all => [:default, :enhanced]
end

task :build => [:'db:migrate', :spec, :'stories:all', :'metrics:all']
