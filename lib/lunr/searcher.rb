module Lunr
  class Searcher < IndexSearcher
    include Index

    def initialize
      super directory, true
    end

    def self.search(param)
      new.search param
    end

    def search(param)
      query = Query.for(param)
      super(query, nil, 10).scoreDocs.map do |score_doc|
        attributes = {}
        doc(score_doc.doc).fields.each do |field|
          attributes.store field.name, field.string_value
          highlight = Highlighter.new(QueryScorer.new(query)).get_best_fragment(Analyzer.new, ALL, field.string_value)
          attributes[:highlight] = highlight if highlight
        end
        attributes
      end
    end

  end
end
