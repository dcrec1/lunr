RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'less'
  config.gem 'haml'
  config.gem 'crack'
  config.gem 'nokogiri'
  config.gem 'pdf-toolkit', :lib => "pdf/toolkit"
  config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  config.time_zone = 'UTC'
end
