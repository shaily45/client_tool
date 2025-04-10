# frozen_string_literal: true

require 'json'
require 'singleton'

class DataStore
  include Singleton

  attr_reader :data, :fields, :availabe_fields

  def load(file_path)
    @data = JSON.parse(File.read(file_path))
    @fields = @data.first&.keys || []
    @availabe_fields = fields.join(', ')
  rescue StandardError => e
    puts "Error loading file: #{e.message}"
  end
end
