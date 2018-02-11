module AresMUSH
  module Forum
    class ForumPostCmd
      include CommandHandler
      
      attr_accessor :category_name, :subject, :message
      
      def parse_args
        if (cmd.args =~ /^[^=\/]+=[^\/=]+\/.+/)
          args = cmd.parse_args(/(?<name>[^\=]+)=(?<subject>[^\/]+)\/(?<message>.+)/)
        else
          args = cmd.parse_args(/(?<name>[^\/]+)\/(?<subject>[^\=]+)\=(?<message>.+)/)
        end
        self.category_name = trim_arg(args.name)
        self.subject = trim_arg(args.subject)
        self.message = args.message
      end
      
      def required_args
        [ self.category_name, self.subject, self.message ]
      end
      
      def handle   
        if (self.category_name.to_i > 0 && self.subject.to_i > 0)
          Forum.with_a_post(self.category_name, self.subject, client, enactor) do |category, post|
            Forum.reply(category, post, enactor, self.message, client)
          end
        else
          Forum.post(self.category_name, self.subject, self.message, enactor, client)
        end
      end
    end
  end
end