class Document

  attr_reader :attributes, :id

  def initialize(attributes = {})
    @attributes = attributes.stringify_keys
    @id = @attributes.delete('id') || ''
  end

  def save
    index = Writer.new
    document = org.apache.lucene.document.Document.new
    _all = []
    @attributes.each do |key, value|
      document.add Field.new key, value, Field::Store::YES, Field::Index::ANALYZED
      _all << value
    end
    document.add Field.new ID_FIELD, @id, Field::Store::YES, Field::Index::NOT_ANALYZED
    document.add Field.new ALL_FIELD, _all.join(' '), Field::Store::NO, Field::Index::ANALYZED
    index.add_document document
    index.close
  end

  def destroy
    index = Writer.new
    index.delete_documents Term.new(ID_FIELD, @id)
    index.close
  end

  def update_attributes(new_attributes)
    destroy
    self.class.create!(attributes.merge new_attributes)
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
      search_by_attributes ALL_FIELD => param
    end
  end

  def self.search_by_attributes(attributes)
    searcher = Searcher.new
    query = TermQuery.new Term.new(attributes.keys.first.to_s, attributes.values.first)
    searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
      attributes = {}
      searcher.doc(score_doc.doc).get_fields.each do |field|
        attributes.store field.name, field.string_value
      end
      Document.new attributes
    end
  end

  private

  ID_FIELD = 'id'
  ALL_FIELD = '_all'

  def method_missing(method_name, *args)
    @attributes[method_name.to_s]
  end
end
