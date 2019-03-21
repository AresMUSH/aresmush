module AresMUSH
  module Mail
    class MailReportCmd
      include CommandHandler
           
      attr_accessor :num
      attr_accessor :comment
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.num = trim_arg(args.arg1)
        self.comment = args.arg2
      end

      def required_args
        [ self.num, self.comment ]
      end
      
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |msg|          
          template = MessageTemplate.new(enactor, msg)
          
          body = t('mail.mail_reported_body', :name => msg.author_name, :reporter => enactor_name)
          body << self.comment
          body << "%R-------%R"
          body << template.render

          Jobs.create_job(Jobs.trouble_category, t('mail.mail_reported_title'), body, Game.master.system_character)
          client.emit_success t('mail.mail_reported')
        end
      end
    end
  end
end
