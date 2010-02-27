# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'metric_fu'

namespace :stories do
  task :all do
    system "jruby -S cucumber"
  end
end

task :build => [:'db:migrate', :spec, :'stories:all', :'metrics:all']

MetricFu::Configuration.run do |config|
  config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :reek, :roodi]
end