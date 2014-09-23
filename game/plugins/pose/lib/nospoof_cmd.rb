module AresMUSH
  module Pose
    class NospoofCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :value
      
      def initialize
        self.required_args = ['value']
        self.help_topic = 'nospoof'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("nospoof")
      end
      
      def crack!
        self.value = cmd.args.nil? ? nil : trim_input(cmd.args).downcase
      end
      
      def check_status
        values = ['on', 'off']
        return t('dispatcher.invalid_on_off_option') if !values.include?(self.value)
      end
      
      def handle
        client.char.nospoof = (self.value == "on")
        client.char.save
        client.emit_success t('pose.nospoof_set', :status => self.value)
      end
    end
  end
end
