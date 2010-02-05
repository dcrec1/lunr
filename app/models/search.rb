class Search
  def initialize(search_result)
    @documents = search_result
    @suggest = search_result.suggest
  end
end