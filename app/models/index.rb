class Index
  PATH = RAILS_ROOT + "/db/lucene/#{RAILS_ENV}"

  def self.directory
    FSDirectory.open java.io.File.new(PATH)
  end

  def self.open
    overwrite = Dir[PATH + '/*'].size < 1
    IndexWriter.new directory, analizer, overwrite, IndexWriter::MaxFieldLength::UNLIMITED
  end

  private

  def self.analizer
    SimpleAnalyzer.new
  end
end
