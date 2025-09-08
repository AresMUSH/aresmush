module AresMUSH
    module Dotcount

      def self.version
        "1.0"
      end  

      def self.calculate_dots(name, client, enactor)
        max_attrs = Global.read_config("fs3skills", "max_points_on_attrs")/2 + Global.read_config("fs3skills", "attr_dots_beyond_chargen_max") + Global.read_config('fs3skills', 'attributes').length * 2
        max_action = Global.read_config("fs3skills", "max_points_on_action") + Global.read_config("fs3skills", "action_dots_beyond_chargen_max") + Global.read_config('fs3skills', 'action_skills').length
        poor_attr = false
        ClassTargetFinder.with_a_character(name, client, enactor) do |model|
          if FS3Skills::AbilityPointCounter.points_on_attrs(model) == 0 && FS3Skills::AbilityPointCounter.points_on_action(model) == 0
            return false
          end  
          spent_attrs = FS3Skills::AbilityPointCounter.points_on_attrs(model)/2 + Global.read_config('fs3skills', 'attributes').length * 2
          spent_action = FS3Skills::AbilityPointCounter.points_on_action(model) + Global.read_config('fs3skills', 'action_skills').length
          model.fs3_attributes.each do |attr|
              if attr.rating == 1
                  max_attrs -= 1
                  spent_attrs -= 1
                  poor_attr = true
              end
            end
            remaining_attrs = max_attrs - spent_attrs
            remaining_action = max_action - spent_action
            current_xp = model.xp
            {
              "max_xp" => Global.read_config("fs3skills", "max_xp_hoard"),
              "current_xp" => current_xp,
              "max_attrs" => max_attrs,
              "max_action" => max_action,
              "spent_attrs" => spent_attrs,
              "spent_action" => spent_action,
              "remaining_action" => remaining_action,
              "remaining_attrs" => remaining_attrs,
              "poor_attr" => poor_attr,
            }
        end
      end 

    end
  end