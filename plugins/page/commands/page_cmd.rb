module AresMUSH
  module Page
    class PageCmd
      include CommandHandler

      attr_accessor :names, :message
      
      def parse_args
        if (!cmd.args)
          self.names = []
        elsif (cmd.args.start_with?("="))
          self.names = enactor.last_paged
          self.message = cmd.args.after("=")
        elsif (cmd.args.include?("="))
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          
          # Catch the common mistake of last-paging someone a link.
          if (args.arg1 && (args.arg1.include?("http://") || args.arg1.include?("https://")) )
            self.names = enactor.last_paged
            self.message = "#{args.arg1}=#{args.arg2}"
          else
            self.names = list_arg(args.arg1)
            self.message = trim_arg(args.arg2)
          end
        else
          self.names = enactor.last_paged
          self.message = cmd.args
        end
      end
      
      def check_page_target
        return t('page.target_missing') if !self.names || self.names.empty?
        return nil
      end
      
      def handle
        result = Page.get_receipients(self.names, enactor)
        if (result[:error])
          client.emit_failure result[:error]
          return
        end
        
        Page.send_page(enactor, result[:recipients], self.message, client)
        
        enactor.update(last_paged: self.names)
      end
      
      def log_command
        # Don't log pages
      end
    end
  end
end
