module AresMUSH
  module Pose
    class ReposeNudgeCmd
      include CommandHandler
           
      attr_accessor :option

      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'repose'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(repose_nudge: self.option.is_on?)
        client.emit_success t("pose.repose_nudge_#{self.option.is_on? ? 'on' : 'off'}")
      end
    end
  end
end