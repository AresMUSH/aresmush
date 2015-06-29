module AresMUSH
  module Manage
    class FindCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :search_class, :name
      
      def initialize
        self.required_args = ['search_class']
        self.help_topic = 'find'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("find")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        
        self.search_class = trim_input(cmd.args.arg1).titleize
        self.name = trim_input(cmd.args.arg2)
      end

      def handle
        begin
          c = AresMUSH.const_get(self.search_class)
          
          if (!Manage.can_manage_object?(client.char, c.new))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (self.name.nil?)
            objects = c.all
          else
            objects = c.all.select { |o| o.name_upcase =~ /#{self.name.upcase}/ }
          end
        rescue
          client.emit_failure t('manage.invalid_search_class')
          return
        end
          
        objects = objects.sort { |a,b| a.name_upcase <=> b.name_upcase}
        objects = objects.map { |r| "#{r.id} #{r.name}"}
        client.emit BorderedDisplay.list(objects, t('manage.find_results'))
      end
    end
  end
end
