class Document

  PATH = RAILS_ROOT + "/db/lucene/#{RAILS_ENV}"

  def initialize(attributes)
    @attributes = attributes.stringify_keys
  end

  def save
    analizer = SimpleAnalyzer.new
    writer = IndexWriter.new directory, analizer, true, IndexWriter::MaxFieldLength::UNLIMITED
    document = org.apache.lucene.document.Document.new
    @attributes.each do |key, value|
      document.add Field.new key, value, Field::Store::YES, Field::Index::ANALYZED
    end
    writer.add_document document
    writer.close
  end

  def self.create!(attributes)
    new(attributes).save
  end

  def self.search(attributes)
    searcher = IndexSearcher.new directory, true
    term = Term.new attributes.keys.first.to_s, attributes.values.first
    query = TermQuery.new term
    searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
      attributes = {}
      searcher.doc(score_doc.doc).get_fields.each do |field|
        attributes.store field.name, field.string_value
      end
      Document.new attributes
    end
  end

  def method_missing(method_name, *args)
    @attributes[method_name.to_s]
  end

  private

  def directory
    FSDirectory.open java.io.File.new(PATH)
  end
end
