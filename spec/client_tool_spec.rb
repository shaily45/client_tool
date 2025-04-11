# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClientTool do
  before(:all) do
    @store = DataStore.instance
    @store.load('clients.json')
    @clients_data = @store.data
  end

  let(:client_tool) { described_class.new }
  let(:search_field) { 'email' }
  let(:search_query) { 'alice' }
  let(:duplicate_field) { 'email' }
  let(:invalid_field) { 'non_existent_field' }

  describe '#run' do
    context 'when user chooses search option' do
      before do
        allow($stdout).to receive(:puts)
        allow(client_tool).to receive(:gets).and_return('1', search_field, search_query)
      end

      it 'calls the search functionality' do
        expect(client_tool).to receive(:handle_search)
        client_tool.run
      end

      it 'displays search results for valid search' do
        search_results = [
          { 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
          { 'full_name' => 'Alice J.', 'email' => 'alice@example.com' }
        ]

        allow(client_tool).to receive(:gets).and_return('1', search_field, search_query)

        fake_searcher = double('Searcher')
        allow(Searcher).to receive(:new).and_return(fake_searcher)
        allow(fake_searcher).to receive(:search).and_return(search_results)

        table = Terminal::Table.new(
          title: 'Search Results (2)',
          headings: %w[full_name email],
          rows: [
            ['Alice Johnson', 'alice@example.com'],
            ['Alice J.', 'alice@example.com']
          ]
        )
        allow(Terminal::Table).to receive(:new).and_return(table)

        captured_output = StringIO.new
        allow($stdout).to receive(:puts) { |msg| captured_output.puts msg }

        client_tool.run

        expect(captured_output.string).to include('Search Results (2)')
        expect(captured_output.string).to include('Alice Johnson')
        expect(captured_output.string).to include('Alice J.')
        expect(captured_output.string).to include('alice@example.com')
      end

      it 'displays "No results found." when search results are empty' do
        allow(Searcher).to receive(:new).and_return(
          double('Searcher', search: [])
        )

        allow(client_tool).to receive(:gets).and_return('1', search_field, search_query)

        captured_output = StringIO.new
        allow($stdout).to receive(:puts) { |msg| captured_output.puts msg }

        client_tool.run

        expect(captured_output.string).to include('No results found.')
      end
    end

    context 'when user chooses duplicate option' do
      before do
        allow($stdout).to receive(:puts)
        allow(client_tool).to receive(:gets).and_return('2', duplicate_field)
      end

      it 'calls the duplicate checking functionality' do
        expect(client_tool).to receive(:handle_duplicates)
        client_tool.run
      end

      it 'displays duplicate results for valid field' do
        duplicates = { 'alice@example.com' => [{ 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
                                               { 'full_name' => 'Alice J.', 'email' => 'alice@example.com' }] }
        allow(DuplicateChecker).to receive(:new).and_return(double('DuplicateChecker', find_duplicates: duplicates))

        table = Terminal::Table.new(title: 'Duplicate email (2)', headings: %w[full_name email],
                                    rows: [['Alice Johnson', 'alice@example.com'], ['Alice J.', 'alice@example.com']])
        allow(Terminal::Table).to receive(:new).and_return(table)

        captured_output = StringIO.new
        allow($stdout).to receive(:puts) { |msg| captured_output.puts msg }

        client_tool.run

        expect(captured_output.string).to include('Duplicate email (2)')
        expect(captured_output.string).to include('Alice Johnson')
        expect(captured_output.string).to include('Alice J.')
        expect(captured_output.string).to include('alice@example.com')
      end
    end

    context 'when user provides invalid input' do
      before do
        allow(client_tool).to receive(:gets).and_return('3')
        allow($stdout).to receive(:puts)
      end

      it 'displays "Exiting..." message' do
        expect($stdout).to receive(:puts).with('Oops! That wasn’t 1 or 2. Exiting... try again next time!')
        client_tool.run
      end
    end

    context 'when user provides invalid field for search' do
      before do
        allow($stdout).to receive(:puts)
        allow(client_tool).to receive(:gets).and_return('1', invalid_field, search_query)
      end

      it 'displays an error message for invalid field in search' do
        expect(client_tool).to receive(:display_field_error)
        client_tool.run
      end
    end

    context 'when user provides invalid field for duplicates' do
      before do
        allow($stdout).to receive(:puts)
        allow(client_tool).to receive(:gets).and_return('2', invalid_field)
      end

      it 'displays an error message for invalid field in duplicates' do
        expect(client_tool).to receive(:display_field_error)
        client_tool.run
      end
    end

    context 'when user provides invalid field and expects error message' do
      before do
        allow($stdout).to receive(:puts)
        allow(client_tool).to receive(:gets).and_return('1', invalid_field, search_query)
      end

      it 'prints the expected error message with invalid field' do
        captured_output = StringIO.new
        allow($stdout).to receive(:puts) { |msg| captured_output.puts msg }

        client_tool.run

        expect(captured_output.string).to include('Invalid field. Try: id, full_name, email')
      end
    end
  end
end
