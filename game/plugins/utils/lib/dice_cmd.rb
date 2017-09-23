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
        
        if (self.num == 0)
          self.num = 1
        end
      end
      
      def required_args
        [ self.num, self.sides ]
      end
      
      def check_too_many_dice
        return t('dice.too_many_dice') if self.num > 10
        return t('dice.no_zero_dice') if self.num <= 0 || self.sides == 0
        return nil
      end
      
      def handle
        results = self.num.times.collect { |d| rand(self.sides) + 1 }
        message	= t('dice.rolls_dice', :name => enactor_name,
        :dice => "#{num}d#{sides}",
        :results => results)

        if (self.private_roll)
          client.emit_ooc message
        else
          enactor_room.emit_ooc	message
        end
      end
      
    end
  end
end
