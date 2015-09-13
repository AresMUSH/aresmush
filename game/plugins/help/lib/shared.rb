module AresMUSH
  module Help
    
    def self.categories
      Global.read_config("help", "categories")
    end
    
    def self.command_to_category_index(command_root)
      match = Help.categories.keys.select { |k| categories[k]["command"].upcase == command_root.upcase }
      match.empty? ? nil : Help.categories[match[0]]
    end
    
    def self.can_access_help?(char, category_index)
      roles = category_index["roles"]
      return true if roles.nil?
      return char.has_any_role?(roles)
    end
  end
end
