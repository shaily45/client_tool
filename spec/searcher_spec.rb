require 'spec_helper'

RSpec.describe Searcher do
  before(:all) do
    @store = DataStore.instance
    @store.load('clients.json')
    @clients_data = @store.data
  end

  let(:search_field) { 'email' }
  let(:search_query) { 'Samuel' }
  let(:searcher) { described_class.new(@clients_data, PartialMatch.new) }

  describe '#search' do
    context 'when matching records are found' do
      it 'returns records that partially match the search query' do
        results = searcher.search(search_field, search_query)

        expect(results).to be_an(Array)
        expect(results.size).to be > 0
        expect(results.first['email']).to match(/Samuel/i)
      end
    end

    context 'when no matching records are found' do
      let(:search_query_no_match) { 'nonexistentemail@example.com' }

      it 'returns an empty array' do
        results = searcher.search(search_field, search_query_no_match)
        expect(results).to eq([])
      end
    end

    context 'when searching with an empty query' do
      it 'returns all records in the specified field' do
        results = searcher.search(search_field, '')
        expect(results.size).to eq(@clients_data.size)
      end
    end
  end
end
