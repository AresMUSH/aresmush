module AresMUSH
  module Chargen
    class AppUnapproveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'app'
        }
      end

      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.is_approved?)
            client.emit_failure t('chargen.not_approved', :name => model.name) 
            return
          end

          model.update(is_approved: false)
          info = model.get_or_create_chargen_info
          info.update(approval_job: nil)
          info.update(locked: false)
          info.save
          client.emit_success t('chargen.app_unapproved', :name => model.name)
        end
      end
    end
  end
end