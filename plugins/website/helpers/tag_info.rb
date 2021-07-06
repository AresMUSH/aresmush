module AresMUSH
  module Website
    def self.title_for_tag_item(model)
      if model.class == AresMUSH::Character
        return model.name
      elsif model.class == AresMUSH::WikiPage
        return model.heading
      elsif model.class == AresMUSH::Scene
        return model.shared ? model.date_title : "##{model.id} - #{model.date_title}"
      elsif model.class == AresMUSH::BbsPost
        return "#{model.bbs_board.name} - #{model.subject}"
      else
        return model.title
      end
    end
    
    def self.is_tag_item_visible?(model, viewer)
      if model.class == AresMUSH::BbsPost
        return Forum.can_read_category?(viewer, model.bbs_board)
      elsif model.class == AresMUSH::Scene
        return model.shared || Scenes.can_read_scene?(viewer, model)
      elsif model.class == AresMUSH::Job
        return Jobs.can_access_job?(viewer, model, true)
      else
        return true
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
      when "AresMUSH::BbsPost"
        return "forum-topic"
      when "AresMUSH::Job"
        return "job"
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
      when "AresMUSH::BbsPost"
        return "Forum Posts"
      when "AresMUSH::Job"
        return "Jobs"
      else
        throw "Unrecognized tag type: #{tag}"
      end
    end
  end
end
