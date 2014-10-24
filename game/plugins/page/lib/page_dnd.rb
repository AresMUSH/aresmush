module AresMUSH
  module Page
    class PageDoNotDisturbCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'page'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("page") && cmd.switch_is?("dnd")
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        client.char.do_not_disturb = (self.option.is_on?)
        client.char.save
        client.emit_success t('page.do_not_disturb_set', :status => self.option)
      end
    end
  end
end
