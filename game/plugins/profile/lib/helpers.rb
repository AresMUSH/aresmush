module AresMUSH
  module Profile
    def self.relationships_by_category(char)
      relations = char.relationships.group_by { |name, data| data['category'] }
      relations.sort_by { |category, relations| Profile.category_order(char, category) }
    end
    
    def self.category_order(char, category)
      char.relationships_category_order.index(category) || (category[0] || "1").ord
    end
  end
end