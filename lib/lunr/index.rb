module Lunr
  module Index
    PATH = RAILS_ROOT + "/db/lucene/#{RAILS_ENV}"

    def directory
      FSDirectory.open java.io.File.new(PATH)
    end
    
    def self.init
      Writer.new {}
    end
  end
end