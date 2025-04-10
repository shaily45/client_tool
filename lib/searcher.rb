class Searcher
  def initialize(data, strategy)
    @data = data
    @strategy = strategy
  end

  def search(field, query)
    @strategy.search(@data, field, query)
  end
end
