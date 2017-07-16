module AresMUSH
  module Wikidot
    def self.site_name
      AresMUSH::Global.read_config('wikidot', 'site_name' )
    end
    
    def self.api_key
      AresMUSH::Global.read_config('secrets', 'wikidot', 'api_key' )
    end    
    
    def self.character_category
      AresMUSH::Global.read_config('wikidot', 'character_category' )
    end
    
    def self.character_page_name(char_name)
      category = Wikidot.character_category ? "#{Wikidot.character_category}:" : ""
      "#{category}#{char_name}"
    end
    
    def self.log_page_title(scene)
      "#{scene.date_title}"
    end
    
    def self.log_page_category(scene)
      categories = AresMUSH::Global.read_config('wikidot', 'log_categories' )
      categories[scene.scene_type] || "log"
    end
    
    def self.log_page_name(scene)
      title = Wikidot.log_page_title(scene)
      category = Wikidot.log_page_category(scene)
      "#{category}:#{title}"
    end
    
    def self.character_tags(char)
      tags = [ char.name, 
            "character", 
            char.group("Colony"), 
            char.group("Department"),
            char.group("Position") ]
      if (char.handle)
        tags << "player:#{char.handle.name}"
      end
      tags.map { |t| t ? t.split.join("-").downcase : nil }
    end
    
    def self.log_tags(scene)
      tags = scene.participants.map { |p| p.name }
      tags << "log"
      tags << scene.scene_type
      tags
    end
  end
end
