require 'spec_helper'

RSpec.describe DuplicateChecker do
  before(:all) do
    @store = DataStore.instance
    @store.load('clients.json')
    @clients_data = @store.data
  end

  let(:duplicate_field) { 'email' }
  let(:unique_field) { 'name' }
  let(:duplicate_checker) { described_class.new(@clients_data, duplicate_field) }

  describe '#find_duplicates' do
    context 'when duplicates exist in the specified field' do
      it 'returns duplicates grouped by field value' do
        expect(@clients_data).not_to be_nil
        expect(@clients_data).to be_an(Array)

        duplicates = duplicate_checker.find_duplicates
        expect(duplicates).to be_a(Hash)
        expect(duplicates).to have_key('jane.smith@yahoo.com')
        expect(duplicates['jane.smith@yahoo.com'].size).to be > 1
      end
    end
  end
end
