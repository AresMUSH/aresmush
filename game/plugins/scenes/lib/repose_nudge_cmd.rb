module AresMUSH
  module Scenes
    class ReposeNudgeCmd
      include CommandHandler
           
      attr_accessor :option, :muted

      def parse_args
        self.option = OnOffOption.new(cmd.args)
        self.muted = cmd.args ? cmd.args.downcase == "mute" : false
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'repose'
        }
      end
      
      def check_status
        return nil if self.muted
        return t('pose.repose_nudge_options') if self.option.validate
      end
      
      def handle
        if (self.muted)
          enactor.update(repose_nudge_muted: true)
          client.emit_success t('pose.repose_nudge_muted')
        else
          enactor.update(repose_nudge_muted: false)
          enactor.update(repose_nudge: self.option.is_on?)
          client.emit_success t("pose.repose_nudge_#{self.option.is_on? ? 'on' : 'off'}")
        end
      end
    end
  end
end