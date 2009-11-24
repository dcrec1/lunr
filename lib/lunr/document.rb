module Lunr
  class Document
    attr_reader :attributes, :id, :highlight

    def initialize(attributes = {})
      @attributes = attributes.stringify_keys
      @highlight = @attributes.delete('highlight')
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

    def self.find(param)
      if param.instance_of? Symbol
        search :all
      else
        search(:id => param).first
      end
    end

    def self.search(param)
      Searcher.search(param).map do |attributes|
        new attributes
      end
    end

    private

    def method_missing(method_name, *args)
      @attributes[method_name.to_s]
    end
  end
end
