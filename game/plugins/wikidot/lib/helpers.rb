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
    
    def self.log_page_name(title, scene_type)
      "#{scene_type}:#{title}"
    end
    
    def self.character_tags(char)
      [ char.name, "character" ]
    end
    
    def self.log_tags(scene_log, log_type = nil)
      tags = scene_log.participants.map { |p| p.name }
      tags << "log"
      if (log_type)
        tags << log_type
      end
      tags
    end
    
    def self.log_types
      AresMUSH::Global.read_config('wikidot', 'log_types' )      
    end
    
    def self.format_log_date(ictime)
      format = AresMUSH::Global.read_config('wikidot', 'log_date_format' )
      ictime.strftime(format)
    end
      
    
  end
end