require_relative './data_store'
require_relative './searcher'
require_relative './duplicate_checker'
require_relative './strategies/partial_match'
require 'terminal-table'


class ClientTool
  attr_reader :data, :fields, :store

  def initialize
    @store = DataStore.instance
    @data = @store.data
    @fields = @store.fields
  end

  def run
    return puts "No data loaded." if data.empty?

    puts "Choose an option:"
    puts "1. Search clients"
    puts "2. Find duplicate entries"
    print "Enter your choice (1 or 2), or press any other key to exit: "

    case gets.chomp
    when "1" then handle_search
    when "2" then handle_duplicates
    else puts "Oops! That wasn’t 1 or 2. Exiting... try again next time!"
    end
  end

  private

  def handle_search
    print "Enter field to search (e.g. #{store.availabe_fields}): "
    field = gets.chomp
    return display_field_error unless fields.include?(field)

    print "Enter search term: "
    query = gets.chomp

    searcher_obj = Searcher.new(data, PartialMatch.new)
    results = searcher_obj.search(field, query)
    return puts "\nNo results found." if results.empty?

    display_table("Search Results", fields, results)
  end

  def handle_duplicates
    print "Enter field to check for duplicates (e.g. #{store.availabe_fields}): "
    field = gets.chomp.strip

    return display_field_error unless fields.include?(field)

    results = DuplicateChecker.new(data, field).find_duplicates

    return puts "\nNo duplicates found." if results.empty?

    puts "\nDuplicate #{field}s found:\n"
    results.each do |value, records|
      display_table("#{field.capitalize}: #{value}", fields, records)
    end
  end

  def display_table(title, headings, rows)
    puts Terminal::Table.new(title: "#{title} (#{rows.size})", headings: headings, rows: rows.map(&:values))
  end

  def display_field_error
    puts "Invalid field. Try: #{store.availabe_fields}"
  end
end