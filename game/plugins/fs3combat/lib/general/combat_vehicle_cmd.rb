module AresMUSH
  module FS3Combat
    class CombatVehicleCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :vehicle, :combatant_type
      
      def initialize
        self.required_args = ['names', 'vehicle', 'combatant_type']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("vehicle")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
          self.names = cmd.args.arg1 ? cmd.args.arg1.split(" ").map { |n| titleize_input(n) } : nil
          self.vehicle = trim_input(cmd.args.arg2)
          self.combatant_type = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_slash_arg2)
          self.names = [ client.name ]
          self.vehicle = titleize_input(cmd.args.arg1)
          self.combatant_type = titleize_input(cmd.args.arg2)
        end
      end

      def check_commas
        return t('fs3combat.dont_use_commas_for_join') if self.names.any? { |n| n.include?(",")}
        return nil
      end
      
      def check_type
        valid_types = [ "Pilot", "Passenger" ]
        return nil if !self.combatant_type       
        return t('fs3combat.use_vehicle_type_cmd') if !valid_types.include?(self.combatant_type)
        return nil
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if !combat
        
        self.names.each_with_index do |name, i|
          Global.dispatcher.queue_timer(i, "Set vehicle type:", client) do
            FS3Combat.with_a_combatant(name, client) do |combat, combatant|   
              # TODO - incomplete     
#              combat.join_vehicle(combatant, type, result.target)
#                      combat.save       
#                      FS3Combat.set_default_gear(client, combatant, type)
            end
          end
        end
      end
    end
  end
end