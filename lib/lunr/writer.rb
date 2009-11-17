module Lunr
  class Writer < IndexWriter
    include Index

    def initialize
      overwrite = Dir[PATH + '/*'].size < 1
      super directory, Analyzer.new, overwrite, IndexWriter::MaxFieldLength::UNLIMITED
      yield self
      close
    end
  end
end