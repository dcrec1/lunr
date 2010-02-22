# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))

require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
end

require File.expand_path(File.dirname(__FILE__) + '/resource_helper')

require 'fakeweb'

def html
  <<HTML
    <html>
      <head><title>HTML Title</title></head>
      <body>This is the body!<script>function hello() {};</script></body>
    </html>
HTML
end

def url
  "http://test.com"
end

FakeWeb.register_uri(:get, url, :body => html)
