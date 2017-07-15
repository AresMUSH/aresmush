module AresMUSH
  module Profile
    def self.relationships_by_category(char)
      char.relationships.group_by { |k, v| v['category'] }
    end
  end
end