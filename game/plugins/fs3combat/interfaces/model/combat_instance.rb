module AresMUSH
  class CombatInstance
    include SupportingObjectModel
      
    field :is_real, :type => Boolean
    field :num, :type => Integer
    
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
      combatant = Combatant.create(:name => name, :combatant_type => combatant_type, :character => char)
      self.combatants << combatant
      emit t('fs3combat.has_joined', :name => name, :type => combatant_type)
    end
    
    def leave(name)
      # TODO - Leave should wipe out mock damage
      emit t('fs3combat.has_left', :name => name)
      combatant = find_combatant(name)
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
  end
end