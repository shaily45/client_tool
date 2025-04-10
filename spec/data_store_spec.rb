# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStore do

  describe '#load' do
    let(:data_store) { described_class.instance }

    before(:all) do
      DataStore.instance.load('clients.json')
    end

    context 'with a valid JSON file' do
      it 'loads data correctly' do
        expect(data_store.data).to be_an(Array)
        expect(data_store.data).not_to be_empty
      end

      it 'sets the fields correctly' do
        expect(data_store.fields).to be_an(Array)
        expect(data_store.fields).not_to be_empty
      end

      it 'sets available fields as comma-separated string' do
        expect(data_store.availabe_fields).to be_a(String)
        expect(data_store.availabe_fields).to include(',')
      end
    end

    context 'when file does not exist' do
      it 'prints an error message' do
        expect {
          data_store.load('non_existing_file.json')
        }.to output(/Error loading file:/).to_stdout
      end
    end
  end
end
