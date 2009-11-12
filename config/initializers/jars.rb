Dir[RAILS_ROOT + "/lib/*.jar"].each { |path| require path.split('/').last.gsub('.jar', '') }
