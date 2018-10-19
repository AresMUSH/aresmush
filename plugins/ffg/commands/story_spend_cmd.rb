module AresMUSH    
  module Ffg
    class StoryPointSpendCmd
      include CommandHandler
      
      attr_accessor :points, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.points = integer_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [self.reason, self.points]
      end      
      
      def check_has_points
        return nil if enactor.ffg_story_points >= self.points
        return t('ffg.not_enough_points')
      end
      
      def handle
        enactor.update(ffg_story_points: enactor.ffg_story_points - self.points)
        Global.logger.info "#{enactor_name} spends #{self.points} story points on #{self.reason}."
        Rooms.emit_ooc_to_room enactor_room, t('ffg.story_point_spent', :name => enactor_name, :reason => self.reason, :points => self.points)
      end
    end
  end
end