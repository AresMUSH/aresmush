module AresMUSH
  module FS3Combat
    class CombatInstance
      attr_accessor :combatants, :organizer, :is_real
      
      def initialize(organizer, is_real = true)
        self.combatants = []
        self.organizer = organizer
        self.is_real = is_real
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
        combatant = Combatant.new(name, combatant_type, char)
        self.combatants << combatant
        emit(t('fs3combat.has_joined', :name => name, :type => combatant_type))
      end
      
      def emit(message, npcmaster = nil)
        message = message + " (#{npcmaster})" if npcmaster
        
        self.combatants.map { |c| c.client }.select { |c| c }.each do |client|
          name = client.name
          client_message = message.gsub(/#{name}/, "%xh%xy#{name}%xn")
          client.emit t('fs3combat.combat_emit', :message => client_message)
        end
      end
      
      def emit_to_organizer(message, npcmaster = nil)
        message = message + " (#{npcmaster})" if npcmaster
        
        client = self.organizer.client
        if (client)
          client.emit t('fs3combat.organizer_emit', :message => message)
        end
      end
    end
  end
end