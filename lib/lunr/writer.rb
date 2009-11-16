module Lunr
  class Writer < IndexWriter
    include Index

    def initialize
      overwrite = Dir[PATH + '/*'].size < 1
      super directory, StandardAnalyzer.new, overwrite, IndexWriter::MaxFieldLength::UNLIMITED
      yield self
      close
    end
  end
end