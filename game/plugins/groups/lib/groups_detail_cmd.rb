module AresMUSH
  module Groups
    class GroupDetailCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'groups'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("group") && cmd.switch.nil?
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        group = Groups.get_group(self.name)
        
        if (group.nil?)
          client.emit_failure t('groups.invalid_group_type')
          return
        end
        
        output = "#{group['desc']}%R%l2%r"
        values = group['values']
        if (values.nil?)
          output << t('groups.open_ended_group')
        else
          values.keys.sort.each do |v|
             output << "%r#{v.titlecase.ljust(20)} #{group['values'][v]}"
          end
        end
        
        client.emit BorderedDisplay.text output, t('groups.group_title', :name => self.name)
      end
    end
  end
end
