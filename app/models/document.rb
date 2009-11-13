class Document
  def initialize(attributes)
    @attributes = attributes.stringify_keys
  end

  def save
    index = Index.open
    document = org.apache.lucene.document.Document.new
    _all = StringIO.new
    @attributes.each do |key, value|
      document.add Field.new key, value, Field::Store::YES, Field::Index::ANALYZED
      _all << value
    end
    document.add Field.new ALL_FIELD, _all.string, Field::Store::YES, Field::Index::ANALYZED
    index.add_document document
    index.close
  end

  def self.create!(attributes)
    new(attributes).save
  end

  def self.search(param)
    if param.instance_of?(Hash)
      search_by_attributes param
    else
      search_by_query param
    end
  end

  def self.search_by_query(query)
    search_by_attributes ALL_FIELD => query
  end

  def self.search_by_attributes(attributes)
    searcher = IndexSearcher.new Index.directory, true
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

  private

  ALL_FIELD = '_all'

  def method_missing(method_name, *args)
    @attributes[method_name.to_s]
  end
end
