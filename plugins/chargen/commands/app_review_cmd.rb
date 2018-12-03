module AresMUSH
  module Chargen
    class AppReviewCmd
      include CommandHandler
      
      attr_accessor :name, :message
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end

      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (model.is_approved?)
            client.emit_failure t('chargen.already_approved', :name => model.name) 
            return
          end
          
          
          job = model.approval_job
          if (!job)
            client.emit_failure t('chargen.no_app_submitted', :name => model.name)
            return
          end
          
          commands = Global.read_config("chargen", "app_review_commands") || []
          commands.each do |command|
            command_text = command % { name: model.name }
            Global.dispatcher.queue_command(client, Command.new(command_text))
          end
          
          desc = Describe.desc_template(model, enactor)
          client.emit desc.render
        end
      end
    end
  end
end