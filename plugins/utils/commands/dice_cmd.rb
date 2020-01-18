module AresMUSH
  module Utils
    class DiceCmd
      include CommandHandler
      
      attr_accessor :num, :sides, :private_roll
      
      def parse_args
        args = cmd.parse_args(/(?<num>[\d]*)[dD](?<sides>[\d]+$)/)
        
        self.num = args.num.to_i 
        self.sides = args.sides.to_i
        self.private_roll = cmd.switch_is?("private")
      end
      
      def required_args
        [ self.num, self.sides ]
      end
      
      def handle
        message = Utils.roll_dice(enactor_name, self.num, self.sides)
        if (!message)
          client.emit_failure t('dice.invalid_dice_string')
          return
        end
        
        if (self.private_roll)
          client.emit_ooc message
        else
          enactor_room.emit_ooc message
          if (enactor_room.scene)
            Scenes.add_to_scene(enactor_room.scene, message, Game.master.system_character, false, true)
          end
        end
      end
      
    end
  end
end
