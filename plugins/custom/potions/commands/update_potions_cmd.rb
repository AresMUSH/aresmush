module AresMUSH
  module Custom
    class UpdatePotionCmd
      include CommandHandler
      # potion/update <name>=<number>/<hours> - Updates a potion's hours to creation
      
      attr_accessor :name, :number, :hours, :potions_creating
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.name = titlecase_arg(args.arg1)
        self.number = integer_arg(args.arg2)
        self.hours = integer_arg(args.arg3)
      end
      
      def required_args
        [ self.name, self.number, self.hours ]
      end
      
      def check_can_set
        return nil if enactor_name == self.name
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        target = Character.find_one_by_name(self.name)
        potions_creating = target.potions_creating.to_a
        potion = potions_creating[self.number - 1]
        
        
        if hours < 1
            PotionsHas.create(name: potion.name, character: target)
            potion.delete
            client.emit_success "#{target.name}'s #{potion.name} potion is now ready."
        else
          potion.update(hours_to_creation: self.hours)
          client.emit_success "#{target.name}'s #{potion.name} potion will now be ready in #{potion.hours_to_creation} hours."
        end
                
      end
      
      

    end
  end
end