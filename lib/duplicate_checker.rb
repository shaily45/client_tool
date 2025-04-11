class DuplicateChecker
  attr_reader :data, :field

  def initialize(data, field)
    @data = data
    @field = field
  end

  def find_duplicates
    grouped = data.group_by { |client| client[field] }
    grouped.select { |_, list| list.size > 1 }
  end
end
