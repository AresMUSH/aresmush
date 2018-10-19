module AresMUSH    
  module Ffg
    class XpAwardCmd
      include CommandHandler
      
      attr_accessor :target_name, :points
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.points = integer_arg(args.arg2)
      end
      
      def required_args
        [self.target_name, self.points]
      end      
      
      def check_is_allowed
        return nil if Ffg.can_manage_abilities?(enactor)
        t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          model.update(ffg_xp: model.ffg_xp + self.points)
          Global.logger.info "#{enactor_name} awarded #{self.points} XP to #{self.target_name}."
          client.emit_success t('ffg.xp_award', :num => self.points, :name => self.target_name)
        end
      end
    end
  end
end