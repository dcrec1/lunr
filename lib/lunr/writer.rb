module Lunr
  class Writer < IndexWriter
    include Index

    def initialize
      overwrite = Dir[PATH + '/*'].size < 1
      super directory, Analyzer.new, overwrite, IndexWriter::MaxFieldLength::UNLIMITED
      yield self
      close
    end

    def self.write(document)
      new do |index|
        index.add_document document
      end
    end

    def self.delete(id)
      new do |index|
        index.delete_documents Lunr::Term.for(ID, id)
      end
    end
  end
end
