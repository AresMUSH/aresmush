module AresMUSH
  module FS3Skills
    class ChargenInfoRequestHandler
      def handle(request)
        
        {
          abilities: FS3Skills::AbilitiesRequestHandler.new.handle(request),
          skill_limits: Global.read_config('fs3skills', 'max_skills_at_or_above'),
          attr_limits: Global.read_config('fs3skills', 'max_attrs_at_or_above'),
          max_attrs: Global.read_config('fs3skills', 'max_points_on_attrs'),
          max_action: Global.read_config('fs3skills', 'max_points_on_action'),
          min_action_skill_rating: Global.read_config('fs3skills', 'allow_unskilled_action_skills') ? 0 : 1,
          max_skill_rating: Global.read_config('fs3skills', 'max_skill_rating'),
          max_attr_rating: Global.read_config('fs3skills', 'max_attr_rating'),
          min_backgrounds: Global.read_config('fs3skills', 'min_backgrounds'),
          free_languages:  Global.read_config('fs3skills', 'free_languages'),
          free_backgrounds:  Global.read_config('fs3skills', 'free_backgrounds'),
          max_ap: Global.read_config('fs3skills', 'max_ap'),
          
        } 
      end
    end
  end
end


