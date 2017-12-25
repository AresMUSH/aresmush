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
          
          Global.dispatcher.queue_command(client, Command.new("app #{model.name}"))
          Global.dispatcher.queue_command(client, Command.new("profile #{model.name}"))
          Global.dispatcher.queue_command(client, Command.new("bg #{model.name}"))
          Global.dispatcher.queue_command(client, Command.new("sheet #{model.name}"))
          
          desc = Describe.desc_template(model, enactor)
          client.emit desc.render
        end
      end
    end
  end
end