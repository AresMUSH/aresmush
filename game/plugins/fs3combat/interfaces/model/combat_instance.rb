module AresMUSH
  class CombatInstance
    include SupportingObjectModel
      
    field :is_real, :type => Boolean
    field :num, :type => Integer
    field :turn_in_progress, :type => Boolean
    field :first_turn, :type => Boolean, :default => true
    
    belongs_to :organizer, :class_name => "AresMUSH::Character", :inverse_of => "nil"  
    has_many :combatants, :inverse_of => 'combat', :dependent => :destroy

    def active_combatants
      combatants.select { |c| !c.is_noncombatant? }.sort_by{ |c| c.name }
    end
    
    def non_combatants
      combatants.select { |c| c.is_noncombatant? }.sort_by{ |c| c.name }
    end
    
    def self.next_num
      max = CombatInstance.all.max_by(&:num)
      max ? max.num + 1 : 1
    end
    
    def is_real?
      is_real
    end
      
    def has_combatant?(name)
      !find_combatant(name).nil?
    end
      
    def find_combatant(name)
      self.combatants.select { |c| c.name_upcase == name.upcase }.first
    end
      
    def join(name, combatant_type, char = nil)
      combatant = Combatant.create(:name => name, 
        :combatant_type => combatant_type, 
        :character => char,
        :team => char ? 1 : 2)
      self.combatants << combatant
      emit t('fs3combat.has_joined', :name => name, :type => combatant_type)
      return combatant
    end

    def set_vehicle(combatant, combatant_type, vehicle)
      # TODO - Incomplete
      # If vehicle already in list, add to crew
      # Check for double pilots
      # If 
      emit t('fs3combat.joined_vehicle', :name => name, :type => combatant_type, :vehicle => vehicle_name)
    end
        
    def leave(name)
      emit t('fs3combat.has_left', :name => name)
      combatant = find_combatant(name)
      combatant.clear_mock_damage          
      self.combatants.delete combatant
      combatant.destroy
    end
      
    def emit(message, npcmaster = nil)
      message = message + "#{npcmaster}"
      self.combatants.each { |c| c.emit(message)}
    end
      
    def emit_to_organizer(message, npcmaster = nil)
      message = message + " (#{npcmaster})" if npcmaster
        
      client = self.organizer.client
      if (client)
        client.emit t('fs3combat.organizer_emit', :message => message)
      end
    end
    
    def roll_initiative
      ability = Global.read_config("fs3combat", "initiative_ability")
      order = []
      self.combatants.each do |c|
        roll = c.roll_initiative(ability)
        order << { :combatant => c, :roll => roll }
      end
      Global.logger.debug "Combat initiative rolls: #{order.map { |o| "#{o[:combatant].name}=#{o[:roll]}" }}"
      order.sort_by { |c| c[:roll] }.map { |c| c[:combatant] }
    end
    
    def ai_action(client, combatant)
      if (combatant.ammo == 0)
        FS3Combat.set_action(client, self, combatant, FS3Combat::ReloadAction, "")
      elsif (!combatant.action)
        target = active_combatants.select { |t| t.team != combatant.team }.shuffle.first
        FS3Combat.set_action(client, self, combatant, FS3Combat::AttackAction, target.name)
      end   
    end
  end
end