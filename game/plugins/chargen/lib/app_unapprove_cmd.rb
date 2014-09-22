module AresMUSH
  module Chargen
    class AppUnapproveCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'app'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("app") && cmd.switch_is?("unapprove")
      end

      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(client.char)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          if (!model.is_approved)
            client.emit_failure t('chargen.not_approved', :name => model.name) 
            return
          end

          model.chargen_locked = false
          model.is_approved = false
          model.approval_job = nil
          model.save
          client.emit_success t('chargen.unapproved', :name => model.name)
        end
      end
    end
  end
end