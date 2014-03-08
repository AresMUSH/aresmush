module AresMUSH
  module Help
    
    def self.valid_commands
      Global.help_reader.categories.values.map { |h| h["command"] }
    end
    
    def self.category_for_command(command_root)
     categories =  Global.help_reader.categories
     categories.keys.each do |key|
        if categories[key]["command"].upcase == command_root.upcase
          return key
        end
      end
      return nil
    end
    
    def self.category_title(category_key)
      category = Global.help_reader.categories[category_key]
      category.nil? ? "" : category["title"]
    end
    
    def self.find_help(category, topic)
      keys = Global.help[category].keys
      title_match = keys.find { |k| k.upcase == topic.upcase }
      Global.help[category][title_match]
    end
    
    def self.find_possible_topics(category, topic)
      possible_topics = Global.help[category].deep_match(/#{topic}/i)
      possible_topics.keys.map { |k| k.titlecase }
    end
  end
end
