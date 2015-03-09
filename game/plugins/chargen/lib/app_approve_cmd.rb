module AresMUSH
  module Chargen
    class AppApproveCmd
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
        cmd.root_is?("app") && cmd.switch_is?("approve")
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
          if (model.is_approved)
            client.emit_failure t('chargen.already_approved', :name => model.name) 
            return
          end

          if (model.approval_job.nil?)
            client.emit_failure t('chargen.no_app_submitted', :name => model.name)
            return
          end
          
          Jobs.close_job(client, model.approval_job, Global.config["chargen"]["messages"]["approval"])
          
          model.is_approved = true
          model.approval_job = nil
          model.save
          client.emit_success t('chargen.app_approved', :name => model.name)
          
          Bbs.system_post_to_bbs_if_configured(
            Global.config['chargen']['arrivals_board'],
            t('chargen.approval_bbs_subject'), 
            t('chargen.approval_bbs_body', :name => model.name))
        end
      end
    end
  end
end