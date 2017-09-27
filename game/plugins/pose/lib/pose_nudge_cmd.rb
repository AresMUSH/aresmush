module AresMUSH
  module Pose
    class PoseNudgeCmd
      include CommandHandler
           
      attr_accessor :option, :muted

      def parse_args
        self.option = OnOffOption.new(cmd.args)
        self.muted = cmd.args ? (cmd.args.downcase == "mute" || cmd.args.downcase == "gag") : false
      end
      
      def required_args
        [ self.option ]
      end
      
      def check_status
        return nil if self.muted
        return t('pose.pose_nudge_options') if self.option.validate
      end
      
      def handle
        if (self.muted)
          enactor.update(pose_nudge_muted: true)
          client.emit_success t('pose.pose_nudge_muted')
        else
          enactor.update(pose_nudge_muted: false)
          enactor.update(pose_nudge: self.option.is_on?)
          client.emit_success t("pose.pose_nudge_#{self.option.is_on? ? 'on' : 'off'}")
        end
      end
    end
  end
end