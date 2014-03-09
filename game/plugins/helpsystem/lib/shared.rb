module AresMUSH
  module HelpSystem
    
    def self.categories
      Global.config["help"]["categories"]
    end
    
    def self.category(name)
      categories[name]
    end
    
    def self.topics(category)
      HelpSystem.category(category)["topics"]
    end
    
    def self.valid_commands
      HelpSystem.categories.values.map { |c| c["command"] }
    end
    
    def self.category_for_command(command_root)
      HelpSystem.categories.keys.find { |k| categories[k]["command"].upcase == command_root.upcase }
    end
    
    def self.category_title(name)
      category = HelpSystem.category(name)
      category.nil? ? "" : category["title"]
    end
    
    def self.find_help(category, topic)
      topics = HelpSystem.topics(category)
      return [] if topics.nil?
      title_match = topics.keys.find { |k| k.upcase == topic.upcase }
      filename = HelpSystem.category(category)["topics"][title_match]
      filename.nil? ? nil : File.read(filename)
    end
    
    def self.search_topics(category, topic)
      topics = HelpSystem.topics(category)
      return [] if topics.nil?
      possible_topics = topics.keys.select { |k| k.upcase =~ /#{topic.upcase}/ }
      possible_topics.map { |k| k.titlecase }
    end
  end
end
