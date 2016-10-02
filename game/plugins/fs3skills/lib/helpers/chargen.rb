module AresMUSH
  module FS3Skills

    def self.app_review(char)
      text = FS3Skills.total_point_review(char)
      text << "%r"
      text << FS3Skills.high_ability_review(char)
      text << "%r"
      text << FS3Skills.interests_review(char)
      text << "%r%r"
      text << FS3Skills.aptitudes_set_review(char)
      text << "%r"
      text << FS3Skills.starting_language_review(char)
      text << "%r"
      text << FS3Skills.starting_skills_check(char)
      text
    end

    def self.app_goals_review(char)
      text = FS3Skills.hook_review(char)
      text << "%r"
      text << FS3Skills.goals_review(char)
      text
    end
      
      
    # Don't forget to save afterward!
    def self.add_unrated_ability(client, char, ability, ability_type)
      list = FS3Skills.get_ability_list_for_type(char, ability_type)
      if (ability_type == :interest || ability_type == :expertise)
        other_list = FS3Skills.get_ability_list_for_type(char, ability_type == :interest ? :expertise : :interest)
      else
        other_list = []
      end
      
      if (list.include?(ability) || other_list.include?(ability))
        client.emit_failure t('fs3skills.item_already_selected', :name => ability)
        return false
      end
      
      list << ability
      client.emit_success t('fs3skills.item_selected', :name => ability)
      return true
    end
    
    # Expects titleized ability name and numeric rating
    # Don't forget to save afterward!
    def self.set_ability(client, char, ability, rating)
      error = FS3Skills.check_ability_name(ability)
      if (error)
        if (client)
          client.emit_failure error
        end
        return false
      end
      
      ability_type = get_ability_type(char, ability)
      ability_hash = get_ability_hash_for_type(char, ability_type)
      
      error = FS3Skills.check_rating(ability_type, rating)
      if (error)
        if (client)
          client.emit_failure error
        end
        return false
      end
      
      update_hash(ability_hash, ability, rating)
      if (client)
        if (char.client == client)
          client.emit_success t("fs3skills.#{ability_type}_set", :name => ability, :rating => rating)
        else
          client.emit_success t("fs3skills.admin_ability_set", :name => char.name, :ability_type => ability_type, :ability_name => ability, :rating => rating)
        end
      end
      return true
    end
    
    def self.cg_points_remaining(char)
      max = Global.read_config("fs3skills", "starting_points")
      points =  points_total(char)
      
      return max - points
    end

    def self.advantages_enabled?
      Global.read_config("fs3skills", "enable_advantages")
    end
  end
end