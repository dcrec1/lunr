module Lunr
  class Searcher < IndexSearcher
    include Index

    def initialize
      super directory, true
    end
  end
end