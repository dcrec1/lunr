module Lunr
  class Search < IndexSearcher
    include Index
    
    def self.by_attributes(attributes)
      query = WildcardQuery.new Lunr::Term.for(attributes.keys.first, attributes.values.first)
      search query
    end
    
    def self.by_query(query_string)
      search StandardQueryParser.new(Analyzer.new).parse(query_string, ALL)
    end

    def initialize
      super directory, true
    end
    
    private
    
    def self.search(query)
      searcher = self.new
      searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
        attributes = {}
        searcher.doc(score_doc.doc).get_fields.each do |field|
          attributes.store field.name, field.string_value
        end
        Document.new attributes
      end
    end
  end
end