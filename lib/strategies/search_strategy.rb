# frozen_string_literal: true

class SearchStrategy
  def search(data, field, query)
    raise NotImplementedError
  end
end
