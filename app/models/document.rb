class Document

  attr_reader :attributes

  def initialize(attributes = {})
    assign_attributes attributes
  end

  def save
    index = Index.open
    document = org.apache.lucene.document.Document.new
    _all = []
    @id = @attributes.delete('id') || ''
    @attributes.each do |key, value|
      document.add Field.new key, value, Field::Store::YES, Field::Index::ANALYZED
      _all << value
    end
    document.add Field.new ID_FIELD, @id, Field::Store::NO, Field::Index::NOT_ANALYZED
    document.add Field.new ALL_FIELD, _all.join(' '), Field::Store::NO, Field::Index::ANALYZED
    index.add_document document
    index.close
  end

  def destroy
    index = Index.open
    index.delete_documents self.class.term(ID_FIELD, @id)
    index.close
  end

  def update_attributes(attributes)
    destroy
    assign_attributes(attributes)
    save
  end

  def self.create!(attributes)
    returning new(attributes) do |model|
      model.save
    end
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
    query = TermQuery.new term(attributes.keys.first.to_s, attributes.values.first)
    searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
      attributes = {}
      searcher.doc(score_doc.doc).get_fields.each do |field|
        attributes.store field.name, field.string_value
      end
      Document.new attributes
    end
  end

  private

  ID_FIELD = '_id'
  ALL_FIELD = '_all'

  def assign_attributes(attributes)
    @attributes = attributes.stringify_keys
  end

  def self.term(name, value)
    Term.new name, value.to_s
  end

  def method_missing(method_name, *args)
    @attributes[method_name.to_s]
  end
end
