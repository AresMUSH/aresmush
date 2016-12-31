module AresMUSH
  module Pose
    class NospoofCmd
      include CommandHandler

      attr_accessor :option

      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'nospoof'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(pose_nospoof: self.option.is_on?)
        client.emit_success t('pose.nospoof_set', :status => self.option)
      end
    end
  end
end
