module AresMUSH
  module Chargen
    class AppUnapproveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'app'
        super
      end
      
      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
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
          client.emit_success t('chargen.app_unapproved', :name => model.name)
        end
      end
    end
  end
end