module AresMUSH
  module Pose
    class NospoofCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :option
      
      def initialize(client, cmd, enactor)
        self.required_args = ['option']
        self.help_topic = 'nospoof'
        super
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.nospoof = self.option.is_on?
        enactor.save
        client.emit_success t('pose.nospoof_set', :status => self.option)
      end
    end
  end
end
