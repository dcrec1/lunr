module Lunr
  class Document
    attr_reader :attributes, :id

    def initialize(attributes = {})
      @attributes = attributes.stringify_keys
      @id = @attributes.delete('id') || object_id.to_s
    end

    def as_json(options = nil)
      @attributes.merge :id => @id
    end

    def save
      Writer.new do |index|
        document = org.apache.lucene.document.Document.new
        _all = []
        @attributes.each do |key, value|
          document.add Field.new key, value, Field::Store::YES, Field::Index::ANALYZED
          _all << value
        end
        document.add Field.new ID, @id, Field::Store::YES, Field::Index::NOT_ANALYZED
        document.add Field.new ALL, _all.join(' '), Field::Store::NO, Field::Index::ANALYZED
        index.add_document document
      end
    end

    def destroy
      Writer.new do |index|
        index.delete_documents Lunr::Term.for(ID, @id)
      end
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

    def self.find(id)
      search(:id => id).first
    end

    def self.search(param)
      if param.instance_of?(Hash)
        Search.by_attributes param
      else
        Search.by_query param
      end
    end

    private

    def method_missing(method_name, *args)
      @attributes[method_name.to_s]
    end
  end
end