module AresMUSH
  module Describe
    class LookDetailCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :name, :target
      
      def initialize
        self.required_args = ['name', 'target']
        self.help_topic = 'detail'
        super
      end
      
      def want_command?(client, cmd)
        (cmd.root_is?("look") && cmd.args =~ /\//) || (cmd.root_is?("detail") && cmd.switch.nil?)
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_slash_arg2)
        self.target = cmd.args.arg1
        self.name = titleize_input(cmd.args.arg2)
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(target, client) do |model|
          if (!model.has_detail?(self.name))
            client.emit_failure t('describe.no_such_detail', :name => self.name)
            return
          end
          
          client.emit BorderedDisplay.text model.detail(self.name), self.name
        end
      end      
    end
  end
end
