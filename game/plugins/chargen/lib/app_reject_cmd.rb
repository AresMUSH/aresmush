module AresMUSH
  module Chargen
    class AppRejectCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :message
      
      def initialize
        self.required_args = ['name', 'message']
        self.help_topic = 'app'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("app") && cmd.switch_is?("reject")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(client.char)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          if (model.is_approved)
            client.emit_failure t('chargen.already_approved', :name => model.name) 
            return
          end

          if (model.approval_job.nil?)
            client.emit_failure t('chargen.no_app_submitted', :name => model.name)
            return
          end
          
          model.chargen_locked = false
          model.save
          
          Jobs.change_job_status(client,
            model.approval_job,
            Global.config["chargen"]["jobs"]["app_hold_status"],
            "#{Global.config["chargen"]["messages"]["rejection"]}%R%R#{self.message}")
                      
          client.emit_success t('chargen.app_rejected', :name => model.name)
        end
      end
    end
  end
end