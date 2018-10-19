module AresMUSH    
  module Ffg
    class StatSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :ability_name, :rating
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.rating = integer_arg(args.arg2)

        case cmd.root
        when "force"
          self.ability_name = :force
        when "wound"
          self.ability_name = :wound
        when "strain"
          self.ability_name = :strain
        end
      end
      
      def required_args
        [self.target_name, self.ability_name, self.rating]
      end
      
      def check_can_set
        return nil if Ffg.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end     
      
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          case (self.ability_name)
          when :force
            model.update(ffg_force_rating: self.rating)
          when :wound
            model.update(ffg_wound_threshold: self.rating)
          when :strain
            model.update(ffg_strain_threshold: self.rating)
          end
          client.emit_success t('ffg.ability_set')
        end
      end
    end
  end
end