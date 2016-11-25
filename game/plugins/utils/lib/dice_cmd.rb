module AresMUSH
  module Utils
    class DiceCmd
      include CommandHandler
      include CommandRequiresArgs
      
      attr_accessor :num, :sides
      
      def crack!
        cmd.crack_args!(/(?<num>[\d]+)[dD](?<sides>[\d]+$)/)
        
        self.num = cmd.args.num.to_i 
        self.sides = cmd.args.sides.to_i
      end
      
      def required_args
        {
          args: [ self.num, self.sides ],
          help: 'die'
        }
      end
      
      def check_too_many_dice
        return t('dice.too_many_dice') if self.num > 10
        return t('dice.no_zero_dice') if self.num == 0 || self.sides == 0
        return nil
      end
      
      def handle
        results = self.num.times.collect { |d| rand(self.sides) + 1 }
        client.emit_ooc results
      end
      
    end
  end
end
