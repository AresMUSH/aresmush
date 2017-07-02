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
    
    def self.log_page_name(scene)
      "#{scene.scene_type}:#{scene.title}"
    end
    
    def self.character_tags(char)
      [ char.name, "character" ]
    end
    
    def self.log_tags(scene)
      tags = scene.participants.map { |p| p.name }
      tags << "log"
      tags << scene.scene_type
      tags
    end
  end
end