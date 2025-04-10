# frozen_string_literal: true

require_relative './search_strategy'

class PartialMatch < SearchStrategy
  def search(data, field, query)
    data.select { |item| item[field]&.downcase&.include?(query.downcase) }
  end
end
