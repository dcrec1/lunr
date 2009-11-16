module Lunr
  class Search < IndexSearcher
    include Index
    
    def self.by_attributes(attributes)
      searcher = self.new
      query = WildcardQuery.new Lunr::Term.for(attributes.keys.first, attributes.values.first)
      searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
        attributes = {}
        searcher.doc(score_doc.doc).get_fields.each do |field|
          attributes.store field.name, field.string_value
        end
        Document.new attributes
      end
    end
    
    def self.by_query(query)
      self.by_attributes ALL => query
    end

    def initialize
      super directory, true
    end
  end
end