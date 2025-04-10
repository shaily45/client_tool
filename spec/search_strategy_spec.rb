# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SearchStrategy do
  it 'raises NotImplementedError when search is called' do
    strategy = SearchStrategy.new
    expect do
      strategy.search(PartialMatch.new, 'name', 'Bob')
    end.to raise_error(NotImplementedError)
  end
end
