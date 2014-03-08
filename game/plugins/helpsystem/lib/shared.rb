module AresMUSH
  module Help
    
    def self.valid_commands
      Global.help_reader.categories.values.map { |h| h["command"] }
    end
    
    def self.category_for_command(command_root)
     categories =  Global.help_reader.categories
     categories.keys.each do |key|
        if categories[key]["command"] == command_root
          return key
        end
      end
      return nil
    end
    
    def self.category_title(category_key)
      category = Global.help_reader.categories[category_key]
      category.nil? ? "" : category["title"]
    end
  end
end
