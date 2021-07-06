module AresMUSH
  module Website
    def self.title_for_tag_item(tag)
      model = Website.find_model_for_tag(tag)
      
      if model.class == AresMUSH::Character
        return model.name
      elsif model.class == AresMUSH::WikiPage
        return model.heading
      elsif model.class == AresMUSH::Scene
        return model.date_title
      else
        return model.title
      end
    end
    
    def self.find_model_for_tag(tag)
      klass = AresMUSH.const_get(tag.content_type)
      if (!klass)
        throw "Unrecognized tag type: #{tag}"
      end
      klass[tag.content_id]
    end
    
    def self.route_for_tag(tag)
      case tag.content_type
      when "AresMUSH::Character"
        return "char"
      when "AresMUSH::WikiPage"
        return "wiki-page"
      when "AresMUSH::Event"
        return "event"
      when "AresMUSH::Scene"
        return "scene"
      when "AresMUSH::Plot"
        return "plot"
      else
        throw "Unrecognized tag type: #{tag}"
      end
    end
    
    def self.title_for_tag_group(tag)
      case tag.content_type
      when "AresMUSH::Character"
        return "Characters"
      when "AresMUSH::WikiPage"
        return "Wiki Pages"
      when "AresMUSH::Event"
        return "Events"
      when "AresMUSH::Scene"
        return "Scenes"
      when "AresMUSH::Plot"
        return "Plots"
      else
        throw "Unrecognized tag type: #{tag}"
      end
    end
  end
end
