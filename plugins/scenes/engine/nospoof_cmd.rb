module AresMUSH
  module Scenes
    class NospoofCmd
      include CommandHandler

      attr_accessor :option

      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        [ self.option ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(pose_nospoof: self.option.is_on?)
        client.emit_success t('scenes.nospoof_set', :status => self.option)
      end
    end
  end
end
