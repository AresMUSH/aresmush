module AresMUSH
  module Test
    def self.die_steps
      [ 'd2', 'd4', 'd6', 'd8', 'd10', 'd12', 'd12+d2', 'd12+d4', 'd12+d6', 'd12+d8', 'd12+d10', 'd12+d12' ]
    end
        
    def self.is_valid_die_step?(step)
      test.die_steps.include?(step)
    end
    
    def self.is_valid_attribute_name?(name)
      return false if !name
      names = Global.read_config('test', 'attributes').map { |a| a['name'].downcase }
      names.include?(name.downcase)
    end
    
    def self.can_manage_attributes?(actor)
      return false if !actor
      actor.has_permission?("manage_apps")
    end
    
    def self.find_attribute(model, attribute_name)
      name_downcase = attribute_name.downcase
      model.cortex_attributes.select { |a| a.name.downcase == name_downcase }.first
    end
  
    def self.format_die_step(input)
      return "" if !input
      input.downcase.gsub(" ", "")
    end
    
    def self.find_attribute_step(char, attribute_name)
      return nil if !attribute_name
      
      case attribute_name.downcase

      end
      
      [ char.test_attributes ].each do |list|
        found = list.select { |a| a.name.downcase == ability_name.downcase }.first
        return found.die_step if found
      end
          end
        end
      end
      return nil
    end
    
    def self.check_max_starting_rating(die_step, config_setting)
      max_step = Global.read_config("test", config_setting)
      max_index = test.die_steps.index(max_step)
      index = test.die_steps.index(die_step)
      
      return nil if !index
      return nil if index <= max_index
      return t('test.starting_rating_limit', :step => max_step)
    end
    
    def self.points_for_step(die_step)
      costs = {
        'd2' => 1,
        'd4' => 2,
        'd6' => 3,
        'd8' => 4,
        'd10' => 5,
        'd12' => 6,
      }

      costs[die_step] || 0
    end

  end
end