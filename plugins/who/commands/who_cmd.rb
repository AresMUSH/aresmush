module AresMUSH
  module Who
    class WhoCmd
      include CommandHandler

      attr_accessor :search
      
      def parse_args
        self.search = titlecase_arg(cmd.args)
      end
      
      def allow_without_login
        true
      end
                  
      def handle        
        online_chars = Who.all_online
        if (self.search)
          online_chars = online_chars.select { |char| char.name =~ /^#{self.search}/ }
        end
        
        template = WhoTemplate.new online_chars
        client.emit template.render
      end      
    end
  end
end
