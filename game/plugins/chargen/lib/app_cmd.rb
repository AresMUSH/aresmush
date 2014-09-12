module AresMUSH
  module Chargen
    class AppCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name

      def want_command?(client, cmd)
        cmd.root_is?("app")
      end

      def crack!
        self.name = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def handle
        if (self.name != client.name && !Chargen.can_approve?(client.char))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          if (model.is_approved?)
            client.emit_failure t('chargen.already_approved')
            return
          end
          
          title = t('chargen.app_title', :name => model.name)
          client.emit BorderedDisplay.list FS3Skills.app_review(model), title
        end
      end
    end
  end
end