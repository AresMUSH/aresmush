module AresMUSH
  module Pose
    class NospoofCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'nospoof'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("nospoof")
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        client.char.nospoof = self.option.is_on?
        client.char.save
        client.emit_success t('pose.nospoof_set', :status => self.option)
      end
    end
  end
end
