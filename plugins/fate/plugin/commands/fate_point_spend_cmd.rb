module AresMUSH    
  module Fate
    class FatePointSpendCmd
      include CommandHandler
      
      attr_accessor :reason
      
      def parse_args
        self.reason = cmd.args
      end
      
      def required_args
        [self.reason]
      end      
      
      def check_has_points
        return nil if enactor.fate_points >= 1
        return t('fate.not_enough_points')
      end
      
      def handle
        enactor.update(fate_points: enactor.fate_points - 1)
        Global.logger.info "#{enactor_name} spends a fate point on #{self.reason}."
        Rooms.emit_ooc_to_room enactor_room, t('fate.fate_point_spent', :name => enactor_name, :reason => self.reason)
      end
    end
  end
end