module AresMUSH
  module Page
    class PageDoNotDisturbCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :value
      
      def initialize
        self.required_args = ['value']
        self.help_topic = 'page'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("page") && cmd.switch_is?("dnd")
      end
      
      def crack!
        self.value = cmd.args.nil? ? nil : trim_input(cmd.args).downcase
      end
      
      def check_status
        values = ['on', 'off']
        return t('dispatcher.invalid_on_off_option') if !values.include?(self.value)
      end
      
      def handle
        client.char.do_not_disturb = (self.value == "on")
        client.emit_success t('page.do_not_disturb_set', :status => self.value)
      end
    end
  end
end
