module AresMUSH
  module Profile
    def self.relationships_by_category(char)
      relations = char.relationships.group_by { |name, data| data['category'] }
      relations.sort_by { |category, relations| Profile.category_order(char, category) }
    end
    
    def self.category_order(char, category)
      char.relationships_category_order.index(category) || (category[0] || "1").ord
    end
    
    def self.can_manage_char_profile?(actor, char)
      return false if !actor
      return true if actor.is_admin?
      return true if actor == char
      
      return AresCentral.is_alt?(actor, char)
    end
  end
end